import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vantage/core/cubits/cubit_error_handler.dart';
import 'package:vantage/core/domain/failures/failure.dart';
import '../../domain/entities/order_status_filter.dart';
import '../../domain/entities/order_summary_entity.dart';
import '../../domain/entities/order_summaries_page_result.dart';
import '../../domain/usecases/delete_order_usecase.dart';
import '../../domain/usecases/get_order_summaries_usecase.dart';
import 'orders_state.dart';

final class OrdersCubit extends Cubit<OrdersState> with CubitErrorHandler<OrdersState> {
  OrdersCubit(this._getOrderSummaries, this._deleteOrder)
    : super(const OrdersInitial()) {
    unawaited(load());
  }

  final GetOrderSummariesUseCase _getOrderSummaries;
  final DeleteOrderUseCase _deleteOrder;

  List<OrderSummaryEntity> _all = [];
  OrderStatusFilter _selectedFilter = OrderStatusFilter.processing;
  bool _hasMore = false;
  String? _nextCursor;
  bool _loadingMore = false;

  Future<void> load() async {
    emit(const OrdersLoading());
    await runGuardedMutation(
      'OrdersCubit.load',
      () async {
        final page = await _getOrderSummaries();
        if (isClosed) return;
        _setFromPage(page);
      },
      onError: (error) {
        if (isClosed) return;
        emit(OrdersError(UnknownFailure(error.toString())));
      },
    );
  }

  Future<void> refresh() async {
    await runGuardedMutation(
      'OrdersCubit.refresh',
      () async {
        final page = await _getOrderSummaries();
        if (isClosed) return;
        _setFromPage(page);
      },
      onError: (error) {
        if (isClosed) return;
        emit(OrdersError(UnknownFailure(error.toString())));
      },
    );
  }

  void _setFromPage(OrderSummariesPageResult page) {
    _all = List<OrderSummaryEntity>.from(page.items);
    _hasMore = page.hasMore;
    _nextCursor = page.nextCursorOrderId;
    _loadingMore = false;
    if (_all.isEmpty) {
      emit(const OrdersEmpty());
    } else {
      emit(_buildLoaded());
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore || _loadingMore || _nextCursor == null) return;
    if (_all.isEmpty) return;
    _loadingMore = true;
    if (state is OrdersLoaded) {
      emit(_buildLoaded());
    }
    final succeeded = await runGuardedMutation(
      'OrdersCubit.loadMore',
      () async {
        final page = await _getOrderSummaries(cursor: _nextCursor);
        if (isClosed) return;
        _all = [..._all, ...page.items];
        _hasMore = page.hasMore;
        _nextCursor = page.nextCursorOrderId;
      },
      onError: (error) {
        if (isClosed) return;
        emit(OrdersError(UnknownFailure(error.toString())));
      },
    );
    _loadingMore = false;
    if (!succeeded || isClosed) return;
    if (_all.isEmpty) {
      emit(const OrdersEmpty());
    } else {
      emit(_buildLoaded());
    }
  }

  void selectFilter(OrderStatusFilter filter) {
    _selectedFilter = filter;
    if (_all.isEmpty) return;
    if (isClosed) return;
    emit(_buildLoaded());
  }

  OrdersLoaded _buildLoaded() {
    final filtered = _all
        .where((order) => order.status == _selectedFilter)
        .toList(growable: false);
    return OrdersLoaded(
      selectedFilter: _selectedFilter,
      filteredOrders: filtered,
      hasMore: _hasMore,
      isLoadingMore: _loadingMore,
    );
  }

  Future<void> removeOrder(String orderId) async {
    await runGuardedMutation(
      'OrdersCubit.removeOrder',
      () async {
        await _deleteOrder(orderId);
        if (isClosed) return;
        _all.removeWhere((order) => order.id == orderId);
        if (_all.isEmpty) {
          emit(const OrdersEmpty());
        } else {
          emit(_buildLoaded());
        }
      },
      onError: (error) {
        if (isClosed) return;
        emit(OrdersError(UnknownFailure(error.toString())));
      },
    );
  }
}
