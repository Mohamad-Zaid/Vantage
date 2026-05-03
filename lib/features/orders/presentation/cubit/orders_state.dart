import 'package:equatable/equatable.dart';
import 'package:vantage/core/domain/failures/failure.dart';

import '../../domain/entities/order_status_filter.dart';
import '../../domain/entities/order_summary_entity.dart';

sealed class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object?> get props => [];
}

final class OrdersInitial extends OrdersState {
  const OrdersInitial();
}

final class OrdersLoading extends OrdersState {
  const OrdersLoading();
}

final class OrdersEmpty extends OrdersState {
  const OrdersEmpty();
}

final class OrdersLoaded extends OrdersState {
  const OrdersLoaded({
    required this.selectedFilter,
    required this.filteredOrders,
    required this.hasMore,
    required this.isLoadingMore,
  });

  final OrderStatusFilter selectedFilter;
  final List<OrderSummaryEntity> filteredOrders;
  final bool hasMore;
  final bool isLoadingMore;

  @override
  List<Object?> get props =>
      [selectedFilter, filteredOrders, hasMore, isLoadingMore];
}

final class OrdersError extends OrdersState {
  const OrdersError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
