import 'package:vantage/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:vantage/features/orders/data/datasources/orders_remote_datasource.dart';
import 'package:vantage/features/orders/domain/entities/order_detail_entity.dart';
import 'package:vantage/features/orders/domain/entities/order_summaries_page_result.dart';
import 'package:vantage/features/orders/domain/repositories/orders_repository.dart';

final class OrdersRepositoryImpl implements OrdersRepository {
  OrdersRepositoryImpl(this._remote, this._getUser);

  final OrdersRemoteDataSource _remote;
  final GetCurrentUserUseCase _getUser;

  Future<String> _requireUserId() async {
    final u = await _getUser();
    if (u == null) {
      throw StateError('Not signed in');
    }
    return u.id;
  }

  @override
  Future<OrderSummariesPageResult> getOrderSummariesPage({String? cursor}) async {
    final u = await _getUser();
    if (u == null) {
      return const OrderSummariesPageResult(items: [], hasMore: false);
    }
    return _remote.listOrdersPage(u.id, startAfterOrderId: cursor);
  }

  @override
  Future<OrderDetailEntity> getOrderDetail(String orderId) async {
    final userId = await _requireUserId();
    return _remote.getOrder(userId, orderId);
  }

  @override
  Future<void> deleteOrder(String orderId) async {
    final userId = await _requireUserId();
    await _remote.deleteOrder(userId, orderId);
  }
}
