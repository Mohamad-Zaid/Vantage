import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.phone,
  });

  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? phone;

  @override
  List<Object?> get props => [id, email, displayName, photoUrl, phone];
}
