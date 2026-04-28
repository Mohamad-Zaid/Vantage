import 'package:equatable/equatable.dart';
import 'package:vantage/core/errors/domain_exceptions.dart';

final class AddressEntity extends Equatable {
  const AddressEntity._({
    required this.id,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
  });

  factory AddressEntity({
    required String id,
    required String street,
    required String city,
    required String state,
    required String zipCode,
  }) {
    _validatePostalFields(
      street: street,
      city: city,
      state: state,
      zipCode: zipCode,
    );
    return AddressEntity._(
      id: id,
      street: street,
      city: city,
      state: state,
      zipCode: zipCode,
    );
  }

  static void _validatePostalFields({
    required String street,
    required String city,
    required String state,
    required String zipCode,
  }) {
    if (street.trim().isEmpty) {
      throw const DomainValidationException('street must not be empty');
    }
    if (city.trim().isEmpty) {
      throw const DomainValidationException('city must not be empty');
    }
    if (state.trim().isEmpty) {
      throw const DomainValidationException('state must not be empty');
    }
    if (zipCode.trim().isEmpty) {
      throw const DomainValidationException('zipCode must not be empty');
    }
  }

  final String id;
  final String street;
  final String city;
  final String state;
  final String zipCode;

  String get singleLinePreview {
    final tail = [city, state, zipCode]
        .map((segment) => segment.trim())
        .where((segment) => segment.isNotEmpty)
        .join(' ');
    final trimmedStreet = street.trim();
    if (trimmedStreet.isEmpty) return tail;
    if (tail.isEmpty) return trimmedStreet;
    return '$trimmedStreet, $tail';
  }

  AddressEntity withId(String newId) => AddressEntity(
        id: newId,
        street: street,
        city: city,
        state: state,
        zipCode: zipCode,
      );

  AddressEntity withStreet(String newStreet) => AddressEntity(
        id: id,
        street: newStreet,
        city: city,
        state: state,
        zipCode: zipCode,
      );

  AddressEntity withCity(String newCity) => AddressEntity(
        id: id,
        street: street,
        city: newCity,
        state: state,
        zipCode: zipCode,
      );

  AddressEntity withState(String newState) => AddressEntity(
        id: id,
        street: street,
        city: city,
        state: newState,
        zipCode: zipCode,
      );

  AddressEntity withZipCode(String newZipCode) => AddressEntity(
        id: id,
        street: street,
        city: city,
        state: state,
        zipCode: newZipCode,
      );

  @override
  List<Object?> get props => [id, street, city, state, zipCode];
}
