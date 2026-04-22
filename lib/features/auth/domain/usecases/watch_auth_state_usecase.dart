import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

final class WatchAuthStateUseCase {
  WatchAuthStateUseCase(this._repository);

  final AuthRepository _repository;

  Stream<UserEntity?> call() => _repository.authStateChanges;
}
