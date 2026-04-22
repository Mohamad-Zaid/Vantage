import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/order_status_filter.dart';
import '../../domain/entities/order_summary_entity.dart';
import '../../domain/entities/order_summaries_page_result.dart';
import '../../domain/usecases/delete_order_usecase.dart';
import '../../domain/usecases/get_order_summaries_usecase.dart';
import 'orders_state.dart';

final class OrdersCubit extends Cubit<OrdersState> {
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
    try {
      final page = await _getOrderSummaries();
      if (isClosed) return;
      _setFromPage(page);
    } catch (e) {
      if (isClosed) return;
      emit(OrdersError(e.toString()));
    }
  }

  // First page only; list stays mounted (no full-screen loading gate).
  Future<void> refresh() async {
    try {
      final page = await _getOrderSummaries();
      if (isClosed) return;
      _setFromPage(page);
    } catch (e) {
      if (isClosed) return;
      emit(OrdersError(e.toString()));
    }
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
    try {
      final page = await _getOrderSummaries(cursor: _nextCursor);
      if (isClosed) return;
      _all = [..._all, ...page.items];
      _hasMore = page.hasMore;
      _nextCursor = page.nextCursorOrderId;
    } catch (e) {
      if (isClosed) return;
      emit(OrdersError(e.toString()));
      _loadingMore = false;
      return;
    }
    _loadingMore = false;
    if (isClosed) return;
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
        .where((o) => o.status == _selectedFilter)
        .toList(growable: false);
    return OrdersLoaded(
      selectedFilter: _selectedFilter,
      filteredOrders: filtered,
      hasMore: _hasMore,
      isLoadingMore: _loadingMore,
    );
  }

  Future<void> removeOrder(String orderId) async {
    try {
      await _deleteOrder(orderId);
      if (isClosed) return;
      _all.removeWhere((o) => o.id == orderId);
      if (_all.isEmpty) {
        emit(const OrdersEmpty());
      } else {
        emit(_buildLoaded());
      }
    } catch (e) {
      if (isClosed) return;
      emit(OrdersError(e.toString()));
    }
  }
}
