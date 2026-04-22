import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:vantage/features/auth/domain/usecases/update_user_profile_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit(this._getUser, this._update) : super(const EditProfileLoading());

  final GetCurrentUserUseCase _getUser;
  final UpdateUserProfileUseCase _update;

  Future<void> load() async {
    final u = await _getUser();
    if (isClosed) return;
    if (u == null) {
      emit(const EditProfileNoSession());
      return;
    }
    emit(
      EditProfileReady(
        user: u,
        newPhotoBytes: null,
        saving: false,
      ),
    );
  }

  void setNewPhotoBytes(List<int> bytes) {
    final s = state;
    if (s is! EditProfileReady) return;
    emit(s.copyWith(newPhotoBytes: bytes, clearError: true));
  }

  void clearSaveError() {
    final s = state;
    if (s is! EditProfileReady) return;
    if (s.saveErrorLocaleKey == null) return;
    emit(s.copyWith(clearError: true));
  }

  Future<void> save(String displayName, String phone) async {
    final start = state;
    if (start is! EditProfileReady) return;
    emit(start.copyWith(saving: true, clearError: true));
    final running = state as EditProfileReady;
    try {
      await _update(
        displayName: displayName,
        phone: phone,
        profileImageBytes: running.newPhotoBytes,
      );
      if (isClosed) return;
      emit(const EditProfileSaveSuccess());
    } catch (_) {
      if (isClosed) return;
      final failed = state as EditProfileReady;
      emit(
        failed.copyWith(
          saving: false,
          saveErrorLocaleKey: LocaleKeys.profile_profileUpdateError,
        ),
      );
    }
  }
}
