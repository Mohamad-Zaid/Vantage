import 'package:cloud_firestore/cloud_firestore.dart';

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

  CollectionReference<Map<String, dynamic>> _col(String userId) =>
      _db.collection('users').doc(userId).collection('addresses');

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
      final ta = a.data()['createdAt'];
      final tb = b.data()['createdAt'];
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
      final ref = col.doc();
      await ref.set({
        'street': address.street,
        'city': address.city,
        'state': address.state,
        'zipCode': address.zipCode,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return;
    }
    await col.doc(address.id).set(
      {
        'street': address.street,
        'city': address.city,
        'state': address.state,
        'zipCode': address.zipCode,
        'updatedAt': FieldValue.serverTimestamp(),
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
      street: m['street'] as String? ?? '',
      city: m['city'] as String? ?? '',
      state: m['state'] as String? ?? '',
      zipCode: m['zipCode'] as String? ?? '',
    );
  }
}
