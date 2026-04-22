import 'package:vantage/features/addresses/domain/repositories/addresses_repository.dart';

final class DeleteAddressUseCase {
  DeleteAddressUseCase(this._repository);

  final AddressesRepository _repository;

  Future<void> call(String userId, String addressId) =>
      _repository.deleteAddress(userId, addressId);
}
