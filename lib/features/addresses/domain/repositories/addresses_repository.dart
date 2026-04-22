import 'package:vantage/features/addresses/domain/entities/address_entity.dart';

abstract interface class AddressesRepository {
  Stream<List<AddressEntity>> watchAddresses(String userId);

  Future<List<AddressEntity>> fetchAddresses(String userId);

  Future<void> upsertAddress(String userId, AddressEntity address);

  Future<void> deleteAddress(String userId, String addressId);
}
