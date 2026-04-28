import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';

import 'package:vantage/core/domain/entities/user_entity.dart';
import 'package:vantage/core/errors/domain_exceptions.dart';
import 'package:vantage/features/auth/domain/repositories/auth_repository.dart';

import '../datasources/auth_remote_datasource.dart';

final class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dataSource);

  final AuthRemoteDataSource _dataSource;

  Future<UserEntity> _toEntity(firebase_auth.User firebaseUser) async {
    final phone = await _dataSource.getProfilePhone(firebaseUser.uid);
    return UserEntity(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
      phone: phone,
    );
  }

  @override
  bool get hasSessionHint => _dataSource.currentUser != null;

  @override
  UserEntity? get currentUser {
    final firebaseUser = _dataSource.currentUser;
    if (firebaseUser == null) return null;
    return UserEntity(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
      phone: null,
    );
  }

  @override
  Stream<UserEntity?> get authStateChanges => _dataSource.authStateChanges.asyncMap(
        (firebaseUser) async {
          if (firebaseUser == null) return null;
          try {
            return await _toEntity(firebaseUser);
          } on firebase_auth.FirebaseAuthException catch (error, stackTrace) {
            debugPrint(
              'AuthRepositoryImpl.authStateChanges map failed: $error\n$stackTrace',
            );
            throw RepositoryException(
              error.message ?? 'Auth error',
              cause: error,
            );
          }
        },
      );

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final firebaseUser = _dataSource.currentUser;
      if (firebaseUser == null) return null;
      return await _toEntity(firebaseUser);
    } on firebase_auth.FirebaseAuthException catch (error, stackTrace) {
      debugPrint('AuthRepositoryImpl.getCurrentUser failed: $error\n$stackTrace');
      throw RepositoryException(error.message ?? 'Auth error', cause: error);
    }
  }

  @override
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _dataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw const RepositoryException('Sign in failed');
      }
      return await _toEntity(firebaseUser);
    } on firebase_auth.FirebaseAuthException catch (error, stackTrace) {
      debugPrint(
        'AuthRepositoryImpl.signInWithEmailAndPassword failed: $error\n$stackTrace',
      );
      throw RepositoryException(error.message ?? 'Auth error', cause: error);
    }
  }

  @override
  Future<UserEntity> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    try {
      final credential = await _dataSource.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      var firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw const RepositoryException('Sign up failed');
      }
      if (firstName != null || lastName != null) {
        final displayName = [firstName, lastName].whereType<String>().join(' ');
        if (displayName.isNotEmpty) {
          await _dataSource.updateDisplayName(displayName);
          final updated = _dataSource.currentUser;
          if (updated != null) {
            firebaseUser = updated;
          }
        }
      }
      return await _toEntity(firebaseUser);
    } on firebase_auth.FirebaseAuthException catch (error, stackTrace) {
      debugPrint(
        'AuthRepositoryImpl.signUpWithEmailAndPassword failed: $error\n$stackTrace',
      );
      throw RepositoryException(error.message ?? 'Auth error', cause: error);
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _dataSource.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (error, stackTrace) {
      debugPrint(
        'AuthRepositoryImpl.sendPasswordResetEmail failed: $error\n$stackTrace',
      );
      throw RepositoryException(error.message ?? 'Auth error', cause: error);
    }
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    try {
      final credential = await _dataSource.signInWithGoogle();
      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw const RepositoryException('Google sign in failed');
      }
      return await _toEntity(firebaseUser);
    } on firebase_auth.FirebaseAuthException catch (error, stackTrace) {
      debugPrint('AuthRepositoryImpl.signInWithGoogle failed: $error\n$stackTrace');
      throw RepositoryException(error.message ?? 'Auth error', cause: error);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _dataSource.signOut();
    } on firebase_auth.FirebaseAuthException catch (error, stackTrace) {
      debugPrint('AuthRepositoryImpl.signOut failed: $error\n$stackTrace');
      throw RepositoryException(error.message ?? 'Auth error', cause: error);
    }
  }

  @override
  Future<void> updateUserProfile({
    required String displayName,
    required String phone,
    List<int>? profileImageBytes,
  }) async {
    try {
      await _dataSource.updateUserProfile(
        displayName: displayName,
        phone: phone,
        profileImageBytes: profileImageBytes,
      );
    } on firebase_auth.FirebaseAuthException catch (error, stackTrace) {
      debugPrint(
        'AuthRepositoryImpl.updateUserProfile failed: $error\n$stackTrace',
      );
      throw RepositoryException(error.message ?? 'Auth error', cause: error);
    }
  }
}
