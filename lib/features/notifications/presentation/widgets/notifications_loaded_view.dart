import 'package:flutter/material.dart';

import 'package:vantage/core/theme/vantage_colors.dart';

import '../../domain/entities/notification_entity.dart';
import 'notification_row_card.dart';

class NotificationsLoadedView extends StatelessWidget {
  const NotificationsLoadedView({
    super.key,
    required this.items,
    required this.cardBg,
    required this.titleColor,
    required this.onDismissed,
  });

  final List<NotificationEntity> items;
  final Color cardBg;
  final Color titleColor;
  final ValueChanged<String> onDismissed;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Padding(
          padding: EdgeInsets.only(bottom: index < items.length - 1 ? 8 : 0),
          child: Dismissible(
            key: ValueKey<String>(item.id),
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
            onDismissed: (_) => onDismissed(item.id),
            child: NotificationRowCard(
              message: item.message,
              cardBg: cardBg,
              iconColor: titleColor,
              bodyColor: titleColor,
            ),
          ),
        );
      },
    );
  }
}
