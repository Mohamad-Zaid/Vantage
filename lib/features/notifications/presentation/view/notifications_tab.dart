import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vantage/core/presentation/failure_display_ext.dart';
import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/di/injection.dart';

import '../cubit/notifications_cubit.dart';
import '../cubit/notifications_state.dart';
import '../widgets/notifications_empty_view.dart';
import '../widgets/notifications_error_view.dart';
import '../widgets/notifications_header.dart';
import '../widgets/notifications_loaded_view.dart';
import '../widgets/notifications_loading_view.dart';

// Owns the notifications cubit for this bottom-nav tab.
class NotificationsTab extends StatefulWidget {
  const NotificationsTab({super.key});

  @override
  State<NotificationsTab> createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab> {
  late final NotificationsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<NotificationsCubit>();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark
        ? Colors.white
        : VantageColors.homeCategoryLabelLight;
    final cardBg = isDark
        ? VantageColors.authBgDark2
        : VantageColors.homeAudiencePillLight;

    return ColoredBox(
      color: VantageColors.scaffoldBackground(Theme.of(context).brightness),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const NotificationsHeader(),
          Expanded(
            child: BlocBuilder<NotificationsCubit, NotificationsState>(
              bloc: _cubit,
              builder: (context, state) {
                return switch (state) {
                  NotificationsInitial() => const SizedBox.shrink(),
                  NotificationsLoading() => const NotificationsLoadingView(),
                  NotificationsEmpty() => NotificationsEmptyView(
                    titleColor: titleColor,
                  ),
                  NotificationsLoaded(:final items) => NotificationsLoadedView(
                      items: items,
                      cardBg: cardBg,
                      titleColor: titleColor,
                      onDismissed: (id) =>
                          unawaited(_cubit.removeNotification(id)),
                    ),
                  NotificationsError(:final failure) => NotificationsErrorView(
                    message: failure.displayMessage,
                    onRetry: _cubit.load,
                  ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}
