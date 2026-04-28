import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:vantage/core/constants/firestore_fields.dart';
import 'package:vantage/core/persistence/firestore_user_scoped_contexts.dart';
import 'package:vantage/features/addresses/domain/entities/address_entity.dart';

abstract interface class AddressesRemoteDataSource {
  Stream<List<AddressEntity>> watchAddresses(String userId);

  Future<List<AddressEntity>> fetchAddresses(String userId);

  Future<void> upsertAddress(String userId, AddressEntity address);

  Future<void> deleteAddress(String userId, String addressId);
}

final class AddressesRemoteDataSourceImpl implements AddressesRemoteDataSource {
  AddressesRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> _col(String userId) => _db
      .collection(FirestoreUserRoot.collectionId)
      .doc(userId)
      .collection(AddressesFirestoreContext.collectionId);

  @override
  Stream<List<AddressEntity>> watchAddresses(String userId) {
    return _col(userId).snapshots().map((snap) {
      return _sortAddressDocs(snap.docs).map(_docToAddress).toList();
    });
  }

  @override
  Future<List<AddressEntity>> fetchAddresses(String userId) async {
    final snap = await _col(userId).get();
    return _sortAddressDocs(snap.docs).map(_docToAddress).toList();
  }

  static List<QueryDocumentSnapshot<Map<String, dynamic>>> _sortAddressDocs(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    docs.sort((a, b) {
      final ta = a.data()[AddressFields.createdAt];
      final tb = b.data()[AddressFields.createdAt];
      if (ta is Timestamp && tb is Timestamp) {
        return tb.compareTo(ta);
      }
      return 0;
    });
    return docs;
  }

  @override
  Future<void> upsertAddress(String userId, AddressEntity address) async {
    final col = _col(userId);
    if (address.id.isEmpty) {
      await col.doc().set({
        AddressFields.street: address.street,
        AddressFields.city: address.city,
        AddressFields.state: address.state,
        AddressFields.zipCode: address.zipCode,
        AddressFields.createdAt: FieldValue.serverTimestamp(),
      });
      return;
    }
    await col.doc(address.id).set(
      {
        AddressFields.street: address.street,
        AddressFields.city: address.city,
        AddressFields.state: address.state,
        AddressFields.zipCode: address.zipCode,
        AddressFields.updatedAt: FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  @override
  Future<void> deleteAddress(String userId, String addressId) {
    return _col(userId).doc(addressId).delete();
  }

  static AddressEntity _docToAddress(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final m = doc.data();
    return AddressEntity(
      id: doc.id,
      street: m[AddressFields.street] as String? ?? '',
      city: m[AddressFields.city] as String? ?? '',
      state: m[AddressFields.state] as String? ?? '',
      zipCode: m[AddressFields.zipCode] as String? ?? '',
    );
  }
}
