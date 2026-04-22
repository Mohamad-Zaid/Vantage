import 'package:equatable/equatable.dart';

final class AddressEntity extends Equatable {
  const AddressEntity({
    required this.id,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
  });

  // Empty for a new address until Firestore returns a document id.
  final String id;
  final String street;
  final String city;
  final String state;
  final String zipCode;

  String get singleLinePreview {
    final tail = [city, state, zipCode]
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .join(' ');
    final s = street.trim();
    if (s.isEmpty) return tail;
    if (tail.isEmpty) return s;
    return '$s, $tail';
  }

  AddressEntity copyWith({
    String? id,
    String? street,
    String? city,
    String? state,
    String? zipCode,
  }) {
    return AddressEntity(
      id: id ?? this.id,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
    );
  }

  @override
  List<Object?> get props => [id, street, city, state, zipCode];
}
