import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../domain/entities/user_entity.dart';

extension FirebaseUserX on firebase_auth.User {
  UserEntity toEntity() => UserEntity(
        id: uid,
        email: email ?? '',
        displayName: displayName,
        photoUrl: photoURL,
        phone: null,
      );
}
