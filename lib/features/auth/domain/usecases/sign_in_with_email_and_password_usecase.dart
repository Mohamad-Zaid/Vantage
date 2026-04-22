import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

final class SignInWithEmailAndPasswordUseCase {
  SignInWithEmailAndPasswordUseCase(this._repository);

  final AuthRepository _repository;

  Future<UserEntity> call({
    required String email,
    required String password,
  }) =>
      _repository.signInWithEmailAndPassword(email: email, password: password);
}
