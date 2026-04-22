import 'package:vantage/features/addresses/domain/entities/address_entity.dart';
import 'package:vantage/features/addresses/domain/repositories/addresses_repository.dart';

final class FetchUserAddressesUseCase {
  const FetchUserAddressesUseCase(this._repository);

  final AddressesRepository _repository;

  Future<List<AddressEntity>> call(String userId) =>
      _repository.fetchAddresses(userId);
}
