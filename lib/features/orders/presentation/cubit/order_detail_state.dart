import 'package:equatable/equatable.dart';
import 'package:vantage/core/domain/failures/failure.dart';

import '../../domain/entities/order_detail_entity.dart';

sealed class OrderDetailState extends Equatable {
  const OrderDetailState();

  @override
  List<Object?> get props => [];
}

final class OrderDetailInitial extends OrderDetailState {
  const OrderDetailInitial();
}

final class OrderDetailLoading extends OrderDetailState {
  const OrderDetailLoading();
}

final class OrderDetailLoaded extends OrderDetailState {
  const OrderDetailLoaded(this.detail);

  final OrderDetailEntity detail;

  @override
  List<Object?> get props => [detail];
}

final class OrderDetailError extends OrderDetailState {
  const OrderDetailError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
