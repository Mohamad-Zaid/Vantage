import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

final class GetCurrentUserUseCase {
  GetCurrentUserUseCase(this._repository);

  final AuthRepository _repository;

  // Avoids wrong splash while [call] is still loading profile fields.
  bool get hasSessionHint => _repository.hasSessionHint;

  Future<UserEntity?> call() => _repository.getCurrentUser();
}
