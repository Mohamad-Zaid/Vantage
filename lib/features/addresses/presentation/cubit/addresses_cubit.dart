import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vantage/features/addresses/domain/entities/address_entity.dart';
import 'package:vantage/features/addresses/domain/usecases/delete_address_usecase.dart';
import 'package:vantage/features/addresses/domain/usecases/fetch_user_addresses_usecase.dart';
import 'package:vantage/features/addresses/domain/usecases/upsert_address_usecase.dart';
import 'package:vantage/features/addresses/domain/usecases/watch_user_addresses_usecase.dart';
import 'package:vantage/features/auth/domain/entities/user_entity.dart';
import 'package:vantage/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:vantage/features/auth/domain/usecases/watch_auth_state_usecase.dart';

import 'addresses_state.dart';

final class AddressesCubit extends Cubit<AddressesState> {
  AddressesCubit({
    required WatchAuthStateUseCase watchAuth,
    required WatchUserAddressesUseCase watchAddresses,
    required FetchUserAddressesUseCase fetchAddresses,
    required UpsertAddressUseCase upsertAddress,
    required DeleteAddressUseCase deleteAddress,
    required GetCurrentUserUseCase getCurrentUser,
  })  : _watchAuth = watchAuth,
        _watchAddresses = watchAddresses,
        _fetchAddresses = fetchAddresses,
        _upsertAddress = upsertAddress,
        _removeAddress = deleteAddress,
        _getCurrentUser = getCurrentUser,
        super(const AddressesInitial()) {
    emit(const AddressesLoading());
    _authSubscription = _watchAuth().listen(_onAuthUserChanged);
  }

  final WatchAuthStateUseCase _watchAuth;
  final WatchUserAddressesUseCase _watchAddresses;
  final FetchUserAddressesUseCase _fetchAddresses;
  final UpsertAddressUseCase _upsertAddress;
  final DeleteAddressUseCase _removeAddress;
  final GetCurrentUserUseCase _getCurrentUser;

  StreamSubscription<UserEntity?>? _authSubscription;
  StreamSubscription<List<AddressEntity>>? _addressesSubscription;

  AddressesLoaded? _lastLoaded;

  void _onAuthUserChanged(UserEntity? userEntity) {
    _addressesSubscription?.cancel();
    _addressesSubscription = null;

    if (userEntity == null) {
      _lastLoaded = const AddressesLoaded([]);
      emit(_lastLoaded!);
      return;
    }

    final uid = userEntity.id;
    _addressesSubscription = _watchAddresses(uid).listen(
      (addresses) {
        _lastLoaded = AddressesLoaded(addresses);
        emit(_lastLoaded!);
      },
      onError: (Object e, StackTrace st) {
        emit(AddressesError(e.toString()));
      },
    );
  }

  Future<void> refresh() async {
    final user = await _getCurrentUser();
    if (user == null) return;
    try {
      final list = await _fetchAddresses(user.id);
      _lastLoaded = AddressesLoaded(list);
      if (!isClosed) {
        emit(_lastLoaded!);
      }
    } catch (e) {
      emit(AddressesError(e.toString()));
      if (_lastLoaded != null) {
        emit(_lastLoaded!);
      }
    }
  }

  // Empty [AddressEntity.id] creates a new document.
  Future<bool> upsert(AddressEntity address) async {
    final user = await _getCurrentUser();
    if (user == null) {
      final prev = _lastLoaded;
      emit(const AddressesNeedSignIn());
      if (prev != null) {
        emit(prev);
      } else {
        emit(const AddressesLoaded([]));
      }
      return false;
    }

    try {
      await _upsertAddress(user.id, address);
      return true;
    } catch (e) {
      emit(AddressesError(e.toString()));
      if (_lastLoaded != null) {
        emit(_lastLoaded!);
      }
      return false;
    }
  }

  Future<bool> deleteAddress(String addressId) async {
    final user = await _getCurrentUser();
    if (user == null) {
      final prev = _lastLoaded;
      emit(const AddressesNeedSignIn());
      if (prev != null) {
        emit(prev);
      } else {
        emit(const AddressesLoaded([]));
      }
      return false;
    }

    try {
      await _removeAddress(user.id, addressId);
      return true;
    } catch (e) {
      emit(AddressesError(e.toString()));
      if (_lastLoaded != null) {
        emit(_lastLoaded!);
      }
      return false;
    }
  }

  @override
  Future<void> close() async {
    await _addressesSubscription?.cancel();
    await _authSubscription?.cancel();
    return super.close();
  }
}
