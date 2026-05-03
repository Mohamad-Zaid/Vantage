import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:vantage/core/auth/auth_aware_cubit.dart';
import 'package:vantage/core/domain/failures/failure.dart';
import 'package:vantage/core/auth/current_user_provider.dart';
import 'package:vantage/core/cubits/cubit_error_handler.dart';
import 'package:vantage/core/domain/entities/user_entity.dart';
import 'package:vantage/features/addresses/domain/entities/address_entity.dart';
import 'package:vantage/features/addresses/domain/usecases/delete_address_usecase.dart';
import 'package:vantage/features/addresses/domain/usecases/fetch_user_addresses_usecase.dart';
import 'package:vantage/features/addresses/domain/usecases/upsert_address_usecase.dart';
import 'package:vantage/features/addresses/domain/usecases/watch_user_addresses_usecase.dart';

import 'addresses_state.dart';

final class AddressesCubit extends AuthAwareCubit<AddressesState>
    with CubitErrorHandler<AddressesState> {
  AddressesCubit({
    required CurrentUserProvider authProvider,
    required WatchUserAddressesUseCase watchAddresses,
    required FetchUserAddressesUseCase fetchAddresses,
    required UpsertAddressUseCase upsertAddress,
    required DeleteAddressUseCase deleteAddress,
  })  : _watchAddresses = watchAddresses,
        _fetchAddresses = fetchAddresses,
        _upsertAddress = upsertAddress,
        _removeAddress = deleteAddress,
        super(const AddressesInitial(), authProvider) {
    emit(const AddressesLoading());
  }

  final WatchUserAddressesUseCase _watchAddresses;
  final FetchUserAddressesUseCase _fetchAddresses;
  final UpsertAddressUseCase _upsertAddress;
  final DeleteAddressUseCase _removeAddress;

  StreamSubscription<List<AddressEntity>>? _addressesSubscription;
  AddressesLoaded? _lastLoaded;

  @override
  void onAuthStateChanged(UserEntity? user) {
    _addressesSubscription?.cancel();
    _addressesSubscription = null;

    if (user == null) {
      _lastLoaded = const AddressesLoaded([]);
      emit(_lastLoaded!);
      return;
    }

    _addressesSubscription = _watchAddresses(user.id).listen(
      (addresses) {
        _lastLoaded = AddressesLoaded(addresses);
        emit(_lastLoaded!);
      },
      onError: (Object error, StackTrace stackTrace) {
        debugPrint(
          'AddressesCubit._watchAddresses subscription failed: $error\n$stackTrace',
        );
        emit(AddressesError(UnknownFailure(error.toString())));
      },
    );
  }

  Future<void> refresh() async {
    final user = currentUser;
    if (user == null) return;
    await runGuardedMutation(
      'AddressesCubit.refresh',
      () async {
        final list = await _fetchAddresses(user.id);
        _lastLoaded = AddressesLoaded(list);
        if (!isClosed) emit(_lastLoaded!);
      },
      onError: (error) {
        emit(AddressesError(UnknownFailure(error.toString())));
        final previous = _lastLoaded;
        if (previous != null) emit(previous);
      },
    );
  }

  Future<bool> upsert(AddressEntity address) async {
    final user = currentUser;
    if (user == null) {
      final previous = _lastLoaded;
      emit(const AddressesNeedSignIn());
      emit(previous ?? const AddressesLoaded([]));
      return false;
    }
    final succeeded = await runGuardedMutation(
      'AddressesCubit.upsert',
      () async {
        await _upsertAddress(user.id, address);
      },
      onError: (error) {
        emit(AddressesError(UnknownFailure(error.toString())));
        final previous = _lastLoaded;
        if (previous != null) emit(previous);
      },
    );
    return succeeded;
  }

  Future<bool> deleteAddress(String addressId) async {
    final user = currentUser;
    if (user == null) {
      final previous = _lastLoaded;
      emit(const AddressesNeedSignIn());
      emit(previous ?? const AddressesLoaded([]));
      return false;
    }
    final succeeded = await runGuardedMutation(
      'AddressesCubit.deleteAddress',
      () async {
        await _removeAddress(user.id, addressId);
      },
      onError: (error) {
        emit(AddressesError(UnknownFailure(error.toString())));
        final previous = _lastLoaded;
        if (previous != null) emit(previous);
      },
    );
    return succeeded;
  }

  @override
  Future<void> close() async {
    await _addressesSubscription?.cancel();
    return super.close();
  }
}
