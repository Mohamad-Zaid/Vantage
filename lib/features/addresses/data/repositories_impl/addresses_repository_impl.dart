import 'package:vantage/features/addresses/data/datasources/addresses_remote_datasource.dart';
import 'package:vantage/features/addresses/domain/entities/address_entity.dart';
import 'package:vantage/features/addresses/domain/repositories/addresses_repository.dart';

final class AddressesRepositoryImpl implements AddressesRepository {
  AddressesRepositoryImpl(this._remote);

  final AddressesRemoteDataSource _remote;

  @override
  Stream<List<AddressEntity>> watchAddresses(String userId) =>
      _remote.watchAddresses(userId);

  @override
  Future<List<AddressEntity>> fetchAddresses(String userId) =>
      _remote.fetchAddresses(userId);

  @override
  Future<void> upsertAddress(String userId, AddressEntity address) =>
      _remote.upsertAddress(userId, address);

  @override
  Future<void> deleteAddress(String userId, String addressId) =>
      _remote.deleteAddress(userId, addressId);
}
