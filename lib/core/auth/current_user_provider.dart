import 'package:vantage/core/domain/entities/user_entity.dart';

abstract interface class CurrentUserProvider {
  /// Last known authenticated user; null when signed out.
  /// Returns the Firebase-cached user (phone field may be absent).
  /// Sufficient for auth-gating write operations that only need [UserEntity.id].
  UserEntity? get currentUser;

  Stream<UserEntity?> get authStateChanges;
}
