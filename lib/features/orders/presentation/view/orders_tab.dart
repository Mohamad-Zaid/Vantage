import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vantage/core/theme/app_spacing.dart';
import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/core/widgets/vantage_loading_indicator.dart';
import 'package:vantage/di/injection.dart';
import 'package:vantage/router/app_router.dart';

import '../cubit/orders_cubit.dart';
import '../cubit/orders_state.dart';
import '../widgets/orders_empty_content.dart';
import '../widgets/orders_error_view.dart';
import '../widgets/orders_filter_chips.dart';
import '../widgets/orders_header.dart';
import '../widgets/orders_loaded_list.dart';
import '../widgets/orders_loading_view.dart';

class OrdersTab extends StatefulWidget {
  const OrdersTab({super.key});

  @override
  State<OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab> {
  late final OrdersCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<OrdersCubit>();
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
    final subtitleColor = isDark
        ? Colors.white.withValues(alpha: 0.5)
        : const Color(0x7F272727);

    return ColoredBox(
      color: VantageColors.scaffoldBackground(Theme.of(context).brightness),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const OrdersHeader(),
          Expanded(
            child: BlocBuilder<OrdersCubit, OrdersState>(
              bloc: _cubit,
              builder: (context, state) {
                return switch (state) {
                  OrdersInitial() => const SizedBox.shrink(),
                  OrdersLoading() => const OrdersLoadingView(),
                  OrdersEmpty() => RefreshIndicator(
                    onRefresh: _cubit.refresh,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.5,
                        child: OrdersEmptyContent(titleColor: titleColor),
                      ),
                    ),
                  ),
                  OrdersError(:final message) => RefreshIndicator(
                    onRefresh: _cubit.refresh,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.5,
                        child: OrdersErrorView(
                          message: message,
                          onRetry: _cubit.load,
                        ),
                      ),
                    ),
                  ),
                  OrdersLoaded(
                    :final selectedFilter,
                    :final filteredOrders,
                    :final hasMore,
                    :final isLoadingMore,
                  ) =>
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        OrdersFilterChips(
                          selected: selectedFilter,
                          onSelected: _cubit.selectFilter,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Expanded(
                          child: filteredOrders.isEmpty
                              ? RefreshIndicator(
                                  onRefresh: _cubit.refresh,
                                  child: SingleChildScrollView(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    child: SizedBox(
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              0.4,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          OrdersEmptyContent(
                                            titleColor: titleColor,
                                          ),
                                          if (hasMore) ...[
                                            const SizedBox(height: AppSpacing.md),
                                            TextButton(
                                              onPressed: isLoadingMore
                                                  ? null
                                                  : () {
                                                      unawaited(
                                                        _cubit.loadMore(),
                                                      );
                                                    },
                                              child: isLoadingMore
                                                  ? const SizedBox(
                                                      width: 20,
                                                      height: 20,
                                                      child:
                                                          VantageLoadingIndicator(
                                                        size: 20,
                                                      ),
                                                    )
                                                  : Text(
                                                      LocaleKeys.common_loadMore
                                                          .tr(),
                                                    ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : RefreshIndicator(
                                  onRefresh: _cubit.refresh,
                                  child: OrdersLoadedList(
                                    orders: filteredOrders,
                                    cardBg: cardBg,
                                    titleColor: titleColor,
                                    subtitleColor: subtitleColor,
                                    isLoadingMore: isLoadingMore,
                                    onNearEnd: () {
                                      if (hasMore && !isLoadingMore) {
                                        unawaited(_cubit.loadMore());
                                      }
                                    },
                                    onDismissed: (id) {
                                      unawaited(_cubit.removeOrder(id));
                                    },
                                    onOrderTap: (order) => context.router.push(
                                      OrderDetailRoute(orderId: order.id),
                                    ),
                                  ),
                                ),
                        ),
                      ],
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
