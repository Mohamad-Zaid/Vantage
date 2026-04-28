import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:vantage/core/errors/domain_exceptions.dart';
import 'package:vantage/features/addresses/data/datasources/addresses_remote_datasource.dart';
import 'package:vantage/features/addresses/domain/entities/address_entity.dart';
import 'package:vantage/features/addresses/domain/repositories/addresses_repository.dart';

final class AddressesRepositoryImpl implements AddressesRepository {
  AddressesRepositoryImpl(this._remote);

  final AddressesRemoteDataSource _remote;

  @override
  Stream<List<AddressEntity>> watchAddresses(String userId) {
    return _remote.watchAddresses(userId).handleError((Object e, StackTrace st) {
      debugPrint('AddressesRepositoryImpl.watchAddresses failed: $e\n$st');
      if (e is FirebaseException) {
        throw RepositoryException(e.message ?? 'Firebase error', cause: e);
      }
      throw e;
    });
  }

  @override
  Future<List<AddressEntity>> fetchAddresses(String userId) async {
    try {
      return await _remote.fetchAddresses(userId);
    } on FirebaseException catch (e, st) {
      debugPrint('AddressesRepositoryImpl.fetchAddresses failed: $e\n$st');
      throw RepositoryException(e.message ?? 'Firebase error', cause: e);
    }
  }

  @override
  Future<void> upsertAddress(String userId, AddressEntity address) async {
    try {
      await _remote.upsertAddress(userId, address);
    } on FirebaseException catch (e, st) {
      debugPrint('AddressesRepositoryImpl.upsertAddress failed: $e\n$st');
      throw RepositoryException(e.message ?? 'Firebase error', cause: e);
    }
  }

  @override
  Future<void> deleteAddress(String userId, String addressId) async {
    try {
      await _remote.deleteAddress(userId, addressId);
    } on FirebaseException catch (e, st) {
      debugPrint('AddressesRepositoryImpl.deleteAddress failed: $e\n$st');
      throw RepositoryException(e.message ?? 'Firebase error', cause: e);
    }
  }
}
