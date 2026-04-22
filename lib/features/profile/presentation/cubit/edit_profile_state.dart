import 'package:equatable/equatable.dart';

import 'package:vantage/features/auth/domain/entities/user_entity.dart';

sealed class EditProfileState extends Equatable {
  const EditProfileState();

  @override
  List<Object?> get props => [];
}

class EditProfileLoading extends EditProfileState {
  const EditProfileLoading();
}

class EditProfileNoSession extends EditProfileState {
  const EditProfileNoSession();
}

class EditProfileReady extends EditProfileState {
  const EditProfileReady({
    required this.user,
    this.newPhotoBytes,
    this.saving = false,
    this.saveErrorLocaleKey,
  });

  final UserEntity user;
  final List<int>? newPhotoBytes;
  final bool saving;

  // Locale key for a one-off SnackBar; cleared after the listener runs.
  final String? saveErrorLocaleKey;

  @override
  List<Object?> get props =>
      [user, newPhotoBytes, saving, saveErrorLocaleKey];

  EditProfileReady copyWith({
    UserEntity? user,
    List<int>? newPhotoBytes,
    bool? saving,
    String? saveErrorLocaleKey,
    bool clearError = false,
  }) {
    return EditProfileReady(
      user: user ?? this.user,
      newPhotoBytes: newPhotoBytes ?? this.newPhotoBytes,
      saving: saving ?? this.saving,
      saveErrorLocaleKey: clearError
          ? null
          : (saveErrorLocaleKey ?? this.saveErrorLocaleKey),
    );
  }
}

class EditProfileSaveSuccess extends EditProfileState {
  const EditProfileSaveSuccess();
}
