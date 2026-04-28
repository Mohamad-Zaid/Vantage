import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vantage/core/auth/current_user_provider.dart';
import 'package:vantage/core/domain/entities/user_entity.dart';

abstract class AuthAwareCubit<S> extends Cubit<S> {
  AuthAwareCubit(super.initialState, this._authProvider) {
    _authSub = _authProvider.authStateChanges.listen(onAuthStateChanged);
  }

  final CurrentUserProvider _authProvider;
  late final StreamSubscription<UserEntity?> _authSub;

  /// Sync access to the last-known authenticated user.
  /// Suitable for auth-gating writes that only need [UserEntity.id].
  UserEntity? get currentUser => _authProvider.currentUser;

  void onAuthStateChanged(UserEntity? user);

  @override
  Future<void> close() {
    _authSub.cancel();
    return super.close();
  }
}
