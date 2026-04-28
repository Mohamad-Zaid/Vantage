import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/sign_in_with_email_and_password_usecase.dart';
import '../../domain/usecases/sign_in_with_google_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_with_email_and_password_usecase.dart';
import '../../domain/usecases/watch_auth_state_usecase.dart';
import 'auth_state.dart';

final class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required WatchAuthStateUseCase watchAuthState,
    required SignInWithEmailAndPasswordUseCase signInWithEmailAndPassword,
    required SignUpWithEmailAndPasswordUseCase signUpWithEmailAndPassword,
    required SignInWithGoogleUseCase signInWithGoogle,
    required SignOutUseCase signOut,
  })  : _signInWithEmailAndPassword = signInWithEmailAndPassword,
        _signUpWithEmailAndPassword = signUpWithEmailAndPassword,
        _signInWithGoogle = signInWithGoogle,
        _signOut = signOut,
        super(const AuthInitial()) {
    _authStateSubscription = watchAuthState().listen((user) {
      if (user != null) {
        _emitSafe(AuthAuthenticated(user));
      } else {
        _emitSafe(const AuthUnauthenticated());
      }
    });
  }

  final SignInWithEmailAndPasswordUseCase _signInWithEmailAndPassword;
  final SignUpWithEmailAndPasswordUseCase _signUpWithEmailAndPassword;
  final SignInWithGoogleUseCase _signInWithGoogle;
  final SignOutUseCase _signOut;
  late final StreamSubscription<UserEntity?> _authStateSubscription;

  void _emitSafe(AuthState state) {
    if (!isClosed) emit(state);
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _emitSafe(const AuthLoading());
    try {
      await _signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e, st) {
      debugPrint('AuthCubit.signInWithEmailAndPassword: $e\n$st');
      if (isClosed) return;
      _emitSafe(AuthError(_mapAuthError(e.toString())));
    }
  }

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    _emitSafe(const AuthLoading());
    try {
      await _signUpWithEmailAndPassword(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
    } catch (e, st) {
      debugPrint('AuthCubit.signUpWithEmailAndPassword: $e\n$st');
      if (isClosed) return;
      _emitSafe(AuthError(_mapAuthError(e.toString())));
    }
  }

  Future<void> signInWithGoogle() async {
    _emitSafe(const AuthLoading());
    try {
      await _signInWithGoogle();
    } catch (e, st) {
      debugPrint('AuthCubit.signInWithGoogle: $e\n$st');
      if (isClosed) return;
      _emitSafe(AuthError(_mapAuthError(e.toString())));
    }
  }

  Future<void> signOut() async {
    await _signOut();
    if (isClosed) return;
    _emitSafe(const AuthUnauthenticated());
  }

  @override
  Future<void> close() async {
    await _authStateSubscription.cancel();
    return super.close();
  }

  String _mapAuthError(String msg) {
    if (msg.contains('user-not-found') || msg.contains('wrong-password')) {
      return LocaleKeys.auth_errorInvalidCredentials.tr();
    }
    if (msg.contains('email-already-in-use')) {
      return LocaleKeys.auth_errorEmailInUse.tr();
    }
    if (msg.contains('weak-password')) {
      return LocaleKeys.auth_errorWeakPassword.tr();
    }
    if (msg.contains('invalid-email')) {
      return LocaleKeys.auth_errorInvalidEmail.tr();
    }
    if (msg.contains('network-request-failed')) {
      return LocaleKeys.auth_errorNetwork.tr();
    }
    return msg;
  }
}
