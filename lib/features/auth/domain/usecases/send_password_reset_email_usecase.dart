import '../repositories/auth_repository.dart';

final class SendPasswordResetEmailUseCase {
  SendPasswordResetEmailUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call({required String email}) =>
      _repository.sendPasswordResetEmail(email: email);
}
