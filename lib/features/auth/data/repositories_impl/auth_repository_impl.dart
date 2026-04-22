import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

final class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dataSource);

  final AuthRemoteDataSource _dataSource;

  Future<UserEntity> _toEntity(firebase_auth.User u) async {
    final phone = await _dataSource.getProfilePhone(u.uid);
    return UserEntity(
      id: u.uid,
      email: u.email ?? '',
      displayName: u.displayName,
      photoUrl: u.photoURL,
      phone: phone,
    );
  }

  @override
  bool get hasSessionHint => _dataSource.currentUser != null;

  @override
  Stream<UserEntity?> get authStateChanges => _dataSource.authStateChanges.asyncMap(
        (u) async {
          if (u == null) return null;
          return _toEntity(u);
        },
      );

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = _dataSource.currentUser;
    if (user == null) return null;
    return _toEntity(user);
  }

  @override
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _dataSource.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw firebase_auth.FirebaseAuthException(
        code: 'user-not-found',
        message: 'Sign in failed',
      );
    }
    return _toEntity(user);
  }

  @override
  Future<UserEntity> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    final credential = await _dataSource.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw firebase_auth.FirebaseAuthException(
        code: 'sign-up-failed',
        message: 'Sign up failed',
      );
    }
    if (firstName != null || lastName != null) {
      final displayName = [firstName, lastName].whereType<String>().join(' ');
      if (displayName.isNotEmpty) {
        await _dataSource.updateDisplayName(displayName);
        final updated = _dataSource.currentUser;
        if (updated != null) {
          return _toEntity(updated);
        }
      }
    }
    return _toEntity(user);
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) =>
      _dataSource.sendPasswordResetEmail(email: email);

  @override
  Future<UserEntity> signInWithGoogle() async {
    final credential = await _dataSource.signInWithGoogle();
    final user = credential.user;
    if (user == null) {
      throw firebase_auth.FirebaseAuthException(
        code: 'google-sign-in-failed',
        message: 'Google sign in failed',
      );
    }
    return _toEntity(user);
  }

  @override
  Future<void> signOut() => _dataSource.signOut();

  @override
  Future<void> updateUserProfile({
    required String displayName,
    required String phone,
    List<int>? profileImageBytes,
  }) =>
      _dataSource.updateUserProfile(
        displayName: displayName,
        phone: phone,
        profileImageBytes: profileImageBytes,
      );
}
