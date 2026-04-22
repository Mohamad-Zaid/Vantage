import 'package:vantage/features/addresses/domain/entities/address_entity.dart';
import 'package:vantage/features/addresses/domain/repositories/addresses_repository.dart';

final class UpsertAddressUseCase {
  UpsertAddressUseCase(this._repository);

  final AddressesRepository _repository;

  Future<void> call(String userId, AddressEntity address) =>
      _repository.upsertAddress(userId, address);
}
