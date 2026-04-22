import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

final class SignUpWithEmailAndPasswordUseCase {
  SignUpWithEmailAndPasswordUseCase(this._repository);

  final AuthRepository _repository;

  Future<UserEntity> call({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) =>
      _repository.signUpWithEmailAndPassword(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
}
