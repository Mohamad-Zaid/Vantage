import '../entities/user_entity.dart';

abstract interface class AuthRepository {
  Stream<UserEntity?> get authStateChanges;

  // Firebase may already have [currentUser] while profile load is still in flight.
  bool get hasSessionHint;

  Future<UserEntity?> getCurrentUser();

  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserEntity> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  });

  Future<UserEntity> signInWithGoogle();

  Future<void> sendPasswordResetEmail({required String email});

  Future<void> signOut();

  Future<void> updateUserProfile({
    required String displayName,
    required String phone,
    List<int>? profileImageBytes,
  });
}
