import 'package:equatable/equatable.dart';

import 'order_line_item_entity.dart';
import 'order_timeline_step_entity.dart';

class OrderDetailEntity extends Equatable {
  const OrderDetailEntity({
    required this.id,
    required this.displayNumber,
    required this.itemCount,
    required this.lineItems,
    required this.address,
    required this.phone,
    required this.timeline,
  });

  final String id;
  final String displayNumber;
  final int itemCount;
  final List<OrderLineItemEntity> lineItems;
  final String address;
  final String phone;
  final List<OrderTimelineStepEntity> timeline;

  @override
  List<Object?> get props => [
    id,
    displayNumber,
    itemCount,
    lineItems,
    address,
    phone,
    timeline,
  ];
}
