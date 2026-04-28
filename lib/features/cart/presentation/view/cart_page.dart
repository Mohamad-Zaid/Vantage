import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vantage/core/theme/app_spacing.dart';
import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/core/widgets/vantage_circle_back_button.dart';
import 'package:vantage/core/widgets/vantage_loading_indicator.dart';
import 'package:vantage/core/widgets/vantage_primary_button.dart';
import 'package:vantage/core/constants/cart_constants.dart';
import 'package:vantage/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:vantage/features/cart/presentation/cubit/cart_state.dart'
    show
        CartEmpty,
        CartError,
        CartInitial,
        CartLoaded,
        CartLoading,
        CartNeedSignIn,
        CartState;
import 'package:vantage/features/cart/presentation/widgets/cart_coupon_row.dart';
import 'package:vantage/features/cart/presentation/widgets/cart_empty_view.dart';
import 'package:vantage/features/cart/presentation/widgets/cart_line_tile.dart';
import 'package:vantage/features/cart/presentation/widgets/cart_summary_block.dart';
import 'package:vantage/router/app_router.dart';

@RoutePage()
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor =
        isDark ? Colors.white : VantageColors.homeCategoryLabelLight;
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<CartCubit, CartState>(
          buildWhen: (previous, current) => previous != current,
          builder: (context, state) {
            return switch (state) {
              CartInitial() => const Center(child: VantageLoadingIndicator()),
              CartLoading() => const Center(child: VantageLoadingIndicator()),
              CartNeedSignIn() => Column(
                children: [
                  _CartHeader(
                    titleColor: titleColor,
                    showRemove: false,
                    onBack: () => context.router.maybePop(),
                    onRemoveAll: null,
                  ),
                  const Expanded(
                    child: CartEmptyView(needsSignIn: true),
                  ),
                ],
              ),
              CartEmpty() => Column(
                children: [
                  _CartHeader(
                    titleColor: titleColor,
                    showRemove: false,
                    onBack: () => context.router.maybePop(),
                    onRemoveAll: null,
                  ),
                  const Expanded(
                    child: CartEmptyView(),
                  ),
                ],
              ),
              CartError(:final message) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
                  child: Text(message),
                ),
              ),
              CartLoaded() => _CartWithItems(
                cart: context.read<CartCubit>(),
                state: state,
                titleColor: titleColor,
              ),
            };
          },
        ),
      ),
    );
  }
}

class _CartWithItems extends StatelessWidget {
  const _CartWithItems({
    required this.cart,
    required this.state,
    required this.titleColor,
  });

  final CartCubit cart;
  final CartLoaded state;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CartHeader(
          titleColor: titleColor,
          showRemove: true,
          onBack: () => context.router.maybePop(),
          onRemoveAll: () {
            _confirmClear(context, cart);
          },
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => cart.refresh(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenHorizontal,
                AppSpacing.sm,
                AppSpacing.screenHorizontal,
                AppSpacing.lg,
              ),
              children: [
              for (final line in state.lines) ...[
                CartLineTile(
                  line: line,
                  onDecrement: () {
                    if (line.quantity > 1) {
                      cart.setLineQuantity(line.id, line.quantity - 1);
                    } else {
                      cart.removeLine(line.id);
                    }
                  },
                  onIncrement: () {
                    if (line.quantity < CartConstants.maxLineQuantity) {
                      cart.setLineQuantity(line.id, line.quantity + 1);
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              const SizedBox(height: AppSpacing.sm),
              CartSummaryBlock(
                totals: state.totals,
              ),
              const SizedBox(height: AppSpacing.lg),
              const CartCouponRow(),
            ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenHorizontal,
            0,
            AppSpacing.screenHorizontal,
            AppSpacing.lg,
          ),
          child: VantagePrimaryButton(
            label: LocaleKeys.cart_checkout.tr(),
            onPressed: () => context.router.push(const CheckoutRoute()),
            horizontalPadding: AppSpacing.screenHorizontal,
          ),
        ),
      ],
    );
  }
}

void _confirmClear(BuildContext context, CartCubit cart) {
  showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(LocaleKeys.cart_removeAll.tr()),
      content: Text(LocaleKeys.cart_removeAllConfirm.tr()),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: Text(LocaleKeys.common_cancel.tr()),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
            cart.clearAll();
          },
          child: Text(LocaleKeys.cart_removeAll.tr()),
        ),
      ],
    ),
  );
}

class _CartHeader extends StatelessWidget {
  const _CartHeader({
    required this.titleColor,
    required this.showRemove,
    required this.onBack,
    required this.onRemoveAll,
  });

  final Color titleColor;
  final bool showRemove;
  final VoidCallback onBack;
  final VoidCallback? onRemoveAll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Row(
        children: [
          VantageCircleBackButton(onPressed: onBack),
          Expanded(
            child: Text(
              LocaleKeys.cart_title.tr(),
              textAlign: TextAlign.center,
              style: GoogleFonts.gabarito(
                color: titleColor,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (showRemove && onRemoveAll != null)
            TextButton(
              onPressed: onRemoveAll,
              child: Text(
                LocaleKeys.cart_removeAll.tr(),
                style: GoogleFonts.nunitoSans(
                  color: VantageColors.authPrimaryPurple,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            const SizedBox(width: AppSpacing.inset48),
        ],
      ),
    );
  }
}