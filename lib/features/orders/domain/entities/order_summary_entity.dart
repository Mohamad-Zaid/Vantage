import 'package:equatable/equatable.dart';

import 'order_status_filter.dart';

class OrderSummaryEntity extends Equatable {
  const OrderSummaryEntity({
    required this.id,
    required this.displayNumber,
    required this.itemCount,
    required this.status,
  });

  final String id;
  final String displayNumber;
  final int itemCount;
  final OrderStatusFilter status;

  @override
  List<Object?> get props => [id, displayNumber, itemCount, status];
}
