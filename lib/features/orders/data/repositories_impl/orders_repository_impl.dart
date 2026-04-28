import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:vantage/core/errors/domain_exceptions.dart';
import 'package:vantage/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:vantage/features/orders/data/datasources/orders_remote_datasource.dart';
import 'package:vantage/features/orders/domain/entities/order_detail_entity.dart';
import 'package:vantage/features/orders/domain/entities/order_line_entity.dart';
import 'package:vantage/features/orders/domain/entities/order_summaries_page_result.dart';
import 'package:vantage/features/orders/domain/repositories/orders_repository.dart';

final class OrdersRepositoryImpl implements OrdersRepository {
  OrdersRepositoryImpl(this._remote, this._getUser);

  final OrdersRemoteDataSource _remote;
  final GetCurrentUserUseCase _getUser;

  Future<String> _requireUserId() async {
    final currentUser = await _getUser();
    if (currentUser == null) {
      throw StateError('Not signed in');
    }
    return currentUser.id;
  }

  @override
  Future<OrderSummariesPageResult> getOrderSummariesPage({String? cursor}) async {
    try {
      final currentUser = await _getUser();
      if (currentUser == null) {
        return const OrderSummariesPageResult(items: [], hasMore: false);
      }
      return await _remote.listOrdersPage(
        currentUser.id,
        startAfterOrderId: cursor,
      );
    } on FirebaseException catch (e, st) {
      debugPrint('OrdersRepositoryImpl.getOrderSummariesPage failed: $e\n$st');
      throw RepositoryException(e.message ?? 'Firebase error', cause: e);
    }
  }

  @override
  Future<OrderDetailEntity> getOrderDetail(String orderId) async {
    try {
      final userId = await _requireUserId();
      return await _remote.getOrder(userId, orderId);
    } on OrderNotFoundException {
      rethrow;
    } on FirebaseException catch (e, st) {
      debugPrint('OrdersRepositoryImpl.getOrderDetail failed: $e\n$st');
      throw RepositoryException(e.message ?? 'Firebase error', cause: e);
    }
  }

  @override
  Future<void> deleteOrder(String orderId) async {
    try {
      final userId = await _requireUserId();
      await _remote.deleteOrder(userId, orderId);
    } on FirebaseException catch (e, st) {
      debugPrint('OrdersRepositoryImpl.deleteOrder failed: $e\n$st');
      throw RepositoryException(e.message ?? 'Firebase error', cause: e);
    }
  }

  @override
  Future<String> createOrder(
    String userId, {
    required List<OrderLineEntity> lines,
    required double subtotal,
    required double shipping,
    required double tax,
    required double total,
    required String addressStreet,
    required String addressCity,
    required String addressState,
    required String addressZip,
    required String? addressId,
    required String paymentLabel,
  }) async {
    try {
      return await _remote.createOrderDocument(
        userId,
        lines: lines,
        subtotal: subtotal,
        shipping: shipping,
        tax: tax,
        total: total,
        addressStreet: addressStreet,
        addressCity: addressCity,
        addressState: addressState,
        addressZip: addressZip,
        addressId: addressId,
        paymentLabel: paymentLabel,
      );
    } on FirebaseException catch (e, st) {
      debugPrint('OrdersRepositoryImpl.createOrder failed: $e\n$st');
      throw RepositoryException(e.message ?? 'Firebase error', cause: e);
    }
  }
}
