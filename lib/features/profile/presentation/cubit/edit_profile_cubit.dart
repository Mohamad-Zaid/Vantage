import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:vantage/features/auth/domain/usecases/update_user_profile_usecase.dart';

import 'edit_profile_state.dart';

final class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit(this._getUser, this._update) : super(const EditProfileLoading());

  final GetCurrentUserUseCase _getUser;
  final UpdateUserProfileUseCase _update;

  Future<void> load() async {
    final currentUser = await _getUser();
    if (isClosed) return;
    if (currentUser == null) {
      emit(const EditProfileNoSession());
      return;
    }
    emit(
      EditProfileReady(
        user: currentUser,
        newPhotoBytes: null,
        saving: false,
      ),
    );
  }

  void setNewPhotoBytes(List<int> bytes) {
    final currentState = state;
    if (currentState is! EditProfileReady) return;
    emit(currentState.copyWith(newPhotoBytes: bytes, clearError: true));
  }

  void clearSaveError() {
    final currentState = state;
    if (currentState is! EditProfileReady) return;
    if (currentState.saveErrorLocaleKey == null) return;
    emit(currentState.copyWith(clearError: true));
  }

  Future<void> save(String displayName, String phone) async {
    final start = state;
    if (start is! EditProfileReady) return;
    emit(start.copyWith(saving: true, clearError: true));
    final profileBeingSaved = state as EditProfileReady;
    try {
      await _update(
        displayName: displayName,
        phone: phone,
        profileImageBytes: profileBeingSaved.newPhotoBytes,
      );
      if (isClosed) return;
      emit(const EditProfileSaveSuccess());
    } catch (e, st) {
      if (isClosed) return;
      debugPrint('EditProfileCubit.save failed: $e\n$st');
      final currentState = state;
      if (currentState is! EditProfileReady) return;
      emit(
        currentState.copyWith(
          saving: false,
          saveErrorLocaleKey: LocaleKeys.profile_profileUpdateError,
        ),
      );
    }
  }
}
