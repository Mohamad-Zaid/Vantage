import '../repositories/auth_repository.dart';

final class UpdateUserProfileUseCase {
  const UpdateUserProfileUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call({
    required String displayName,
    required String phone,
    List<int>? profileImageBytes,
  }) =>
      _repository.updateUserProfile(
        displayName: displayName,
        phone: phone,
        profileImageBytes: profileImageBytes,
      );
}
