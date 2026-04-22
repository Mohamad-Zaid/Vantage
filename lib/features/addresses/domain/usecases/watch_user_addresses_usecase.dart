import 'package:vantage/features/addresses/domain/entities/address_entity.dart';
import 'package:vantage/features/addresses/domain/repositories/addresses_repository.dart';

final class WatchUserAddressesUseCase {
  WatchUserAddressesUseCase(this._repository);

  final AddressesRepository _repository;

  Stream<List<AddressEntity>> call(String userId) =>
      _repository.watchAddresses(userId);
}
