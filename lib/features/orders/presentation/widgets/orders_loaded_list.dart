import 'package:flutter/material.dart';

import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/widgets/vantage_loading_indicator.dart';

import '../../domain/entities/order_summary_entity.dart';
import 'order_summary_tile.dart';

class OrdersLoadedList extends StatefulWidget {
  const OrdersLoadedList({
    super.key,
    required this.orders,
    required this.cardBg,
    required this.titleColor,
    required this.subtitleColor,
    required this.onDismissed,
    required this.onOrderTap,
    required this.onNearEnd,
    required this.isLoadingMore,
  });

  final List<OrderSummaryEntity> orders;
  final Color cardBg;
  final Color titleColor;
  final Color subtitleColor;
  final ValueChanged<String> onDismissed;
  final ValueChanged<OrderSummaryEntity> onOrderTap;
  final VoidCallback onNearEnd;
  final bool isLoadingMore;

  @override
  State<OrdersLoadedList> createState() => _OrdersLoadedListState();
}

class _OrdersLoadedListState extends State<OrdersLoadedList> {
  bool _firedEnd = false;

  @override
  void didUpdateWidget(OrdersLoadedList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLoadingMore && !widget.isLoadingMore) {
      _firedEnd = false;
    }
    if (oldWidget.orders.length != widget.orders.length) {
      _firedEnd = false;
    }
  }

  void _onScroll(ScrollNotification n) {
    if (widget.isLoadingMore) return;
    if (n.metrics.pixels < n.metrics.maxScrollExtent - 100) return;
    if (_firedEnd) return;
    _firedEnd = true;
    widget.onNearEnd();
  }

  @override
  Widget build(BuildContext context) {
    final n = widget.orders.length;
    final withFooter = widget.isLoadingMore ? n + 1 : n;
    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        if (n is ScrollUpdateNotification || n is OverscrollNotification) {
          _onScroll(n);
        }
        return false;
      },
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        itemCount: withFooter,
        itemBuilder: (context, index) {
          if (index >= n) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: VantageLoadingIndicator(size: 24),
              ),
            );
          }
          final order = widget.orders[index];
          return Padding(
            padding: EdgeInsets.only(bottom: index < n - 1 ? 12 : 0),
            child: Dismissible(
              key: ValueKey<String>('order_${order.id}'),
              direction: DismissDirection.startToEnd,
              background: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                  color: VantageColors.error.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.delete_outline_rounded,
                  color: Theme.of(context).colorScheme.onError,
                ),
              ),
              onDismissed: (_) => widget.onDismissed(order.id),
              child: OrderSummaryTile(
                order: order,
                cardBg: widget.cardBg,
                titleColor: widget.titleColor,
                subtitleColor: widget.subtitleColor,
                onTap: () => widget.onOrderTap(order),
              ),
            ),
          );
        },
      ),
    );
  }
}
