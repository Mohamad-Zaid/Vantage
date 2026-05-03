import 'package:equatable/equatable.dart';

import 'package:vantage/core/domain/failures/failure.dart';
import 'package:vantage/features/addresses/domain/entities/address_entity.dart';

sealed class AddressesState extends Equatable {
  const AddressesState();

  @override
  List<Object?> get props => [];
}

final class AddressesInitial extends AddressesState {
  const AddressesInitial();
}

final class AddressesLoading extends AddressesState {
  const AddressesLoading();
}

final class AddressesLoaded extends AddressesState {
  const AddressesLoaded(this.addresses);

  final List<AddressEntity> addresses;

  @override
  List<Object?> get props => [addresses];
}

final class AddressesNeedSignIn extends AddressesState {
  const AddressesNeedSignIn();
}

final class AddressesError extends AddressesState {
  const AddressesError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
