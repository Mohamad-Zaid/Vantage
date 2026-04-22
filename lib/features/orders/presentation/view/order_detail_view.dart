import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/core/widgets/vantage_loading_indicator.dart';
import 'package:vantage/di/injection.dart';

import '../../domain/usecases/get_order_detail_usecase.dart';
import '../cubit/order_detail_cubit.dart';
import '../cubit/order_detail_state.dart';
import '../widgets/order_detail_items_card.dart';
import '../widgets/order_detail_nav_bar.dart';
import '../widgets/order_detail_section_title.dart';
import '../widgets/order_detail_shipping_card.dart';
import '../widgets/order_detail_timeline_section.dart';
import '../widgets/orders_error_view.dart';

@RoutePage()
class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({super.key, required this.orderId});

  final String orderId;

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  late final OrderDetailCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = OrderDetailCubit(sl<GetOrderDetailUseCase>(), widget.orderId);
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
    final backBtnBg = isDark
        ? VantageColors.authBgDark2
        : VantageColors.homeAudiencePillLight;
    final backIcon = isDark
        ? Colors.white
        : VantageColors.homeCategoryLabelLight;

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<OrderDetailCubit, OrderDetailState>(
          bloc: _cubit,
          builder: (context, state) {
            return switch (state) {
              OrderDetailInitial() => const SizedBox.shrink(),
              OrderDetailLoading() => const Center(
                child: VantageLoadingIndicator(),
              ),
              OrderDetailError(:final message) => RefreshIndicator(
                onRefresh: _cubit.refresh,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.4,
                    child: OrdersErrorView(
                      message: message,
                      onRetry: _cubit.load,
                    ),
                  ),
                ),
              ),
              OrderDetailLoaded(:final detail) => RefreshIndicator(
                onRefresh: _cubit.refresh,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      OrderDetailNavBar(
                        displayNumber: detail.displayNumber,
                        titleColor: titleColor,
                        buttonBg: backBtnBg,
                        iconColor: backIcon,
                      ),
                      OrderDetailTimelineSection(detail: detail, isDark: isDark),
                      const SizedBox(height: 32),
                      OrderDetailSectionTitle(
                        titleKey: LocaleKeys.orderDetail_orderItems,
                        color: titleColor,
                      ),
                      const SizedBox(height: 12),
                      OrderDetailItemsCard(
                        lineItems: detail.lineItems,
                        itemCount: detail.itemCount,
                        cardBg: cardBg,
                        titleColor: titleColor,
                      ),
                      const SizedBox(height: 32),
                      OrderDetailSectionTitle(
                        titleKey: LocaleKeys.orderDetail_shippingDetails,
                        color: titleColor,
                      ),
                      const SizedBox(height: 12),
                      OrderDetailShippingCard(
                        address: detail.address,
                        phone: detail.phone,
                        cardBg: cardBg,
                        textColor: titleColor,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            };
          },
        ),
      ),
    );
  }
}
