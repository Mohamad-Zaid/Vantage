import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vantage/core/theme/app_spacing.dart';
import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/features/cart/presentation/widgets/cart_money.dart';
import 'package:vantage/features/orders/domain/entities/order_line_item_entity.dart';
import 'package:vantage/features/orders/presentation/cubit/order_detail_items_expansion_cubit.dart';
import 'package:vantage/generated/assets.dart';

class OrderDetailItemsCard extends StatelessWidget {
  const OrderDetailItemsCard({
    super.key,
    required this.lineItems,
    required this.itemCount,
    required this.cardBg,
    required this.titleColor,
  });

  final List<OrderLineItemEntity> lineItems;
  final int itemCount;
  final Color cardBg;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final subC = isDark
        ? Colors.white.withValues(alpha: 0.55)
        : VantageColors.profileTextSecondaryLight;

    if (lineItems.isEmpty) {
      return _HelpSupportCardShell(
        cardBg: cardBg,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Row(
            children: [
              _LeadingIcon(titleColor: titleColor),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  LocaleKeys.orderDetail_itemsLine.tr(
                    namedArgs: {'count': '$itemCount'},
                  ),
                  style: GoogleFonts.nunitoSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: titleColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return BlocProvider(
      create: (_) => OrderDetailItemsExpansionCubit(),
      child: _OrderDetailItemsExpandable(
        lineItems: lineItems,
        itemCount: itemCount,
        cardBg: cardBg,
        titleColor: titleColor,
        subColor: subC,
        theme: theme,
      ),
    );
  }
}

class _OrderDetailItemsExpandable extends StatelessWidget {
  const _OrderDetailItemsExpandable({
    required this.lineItems,
    required this.itemCount,
    required this.cardBg,
    required this.titleColor,
    required this.subColor,
    required this.theme,
  });

  final List<OrderLineItemEntity> lineItems;
  final int itemCount;
  final Color cardBg;
  final Color titleColor;
  final Color subColor;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return _HelpSupportCardShell(
      cardBg: cardBg,
      child: BlocBuilder<OrderDetailItemsExpansionCubit, bool>(
        builder: (context, expanded) {
          return Theme(
            data: theme.copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              collapsedShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              leading: _LeadingIcon(titleColor: titleColor),
              title: Text(
                LocaleKeys.orderDetail_itemsLine.tr(
                  namedArgs: {'count': '$itemCount'},
                ),
                style: GoogleFonts.nunitoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: titleColor,
                ),
              ),
              trailing: AnimatedRotation(
                turns: expanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: SvgPicture.asset(
                  Assets.vectorArrowDown,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    expanded
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              onExpansionChanged: (v) => context
                  .read<OrderDetailItemsExpansionCubit>()
                  .setExpanded(v),
              childrenPadding: const EdgeInsets.only(
                left: 12,
                right: 12,
                bottom: 16,
              ),
              expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < lineItems.length; i++) ...[
                  if (i > 0) const SizedBox(height: AppSpacing.md),
                  _OrderLineRow(
                    line: lineItems[i],
                    titleColor: titleColor,
                    subColor: subColor,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HelpSupportCardShell extends StatelessWidget {
  const _HelpSupportCardShell({
    required this.cardBg,
    required this.child,
  });

  final Color cardBg;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: child,
      ),
    );
  }
}

class _LeadingIcon extends StatelessWidget {
  const _LeadingIcon({required this.titleColor});

  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Center(
        child: SvgPicture.asset(
          Assets.vectorNavWishlistNormal,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(titleColor, BlendMode.srcIn),
        ),
      ),
    );
  }
}

class _OrderLineRow extends StatelessWidget {
  const _OrderLineRow({
    required this.line,
    required this.titleColor,
    required this.subColor,
  });

  final OrderLineItemEntity line;
  final Color titleColor;
  final Color subColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: _LineThumb(url: line.imageUrl),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                line.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.gabarito(
                  color: titleColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                LocaleKeys.cart_lineSize.tr(
                  namedArgs: {'size': line.size},
                ),
                style: GoogleFonts.nunitoSans(
                  color: subColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                LocaleKeys.cart_lineColor.tr(
                  namedArgs: {'color': line.colorLabel},
                ),
                style: GoogleFonts.nunitoSans(
                  color: subColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                '${LocaleKeys.productDetail_quantity.tr()}: ${line.quantity}',
                style: GoogleFonts.nunitoSans(
                  color: subColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          CartMoney.usd(line.lineTotal),
          style: GoogleFonts.gabarito(
            color: VantageColors.authPrimaryPurple,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _LineThumb extends StatelessWidget {
  const _LineThumb({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    const w = 56.0;
    const h = 56.0;
    final placeholder = ColoredBox(
      color: VantageColors.primaryTintLight,
      child: const Center(
        child: Icon(Icons.image_outlined, size: 24),
      ),
    );
    if (url.isEmpty) {
      return SizedBox(width: w, height: h, child: placeholder);
    }
    if (url.startsWith('assets/')) {
      return SizedBox(
        width: w,
        height: h,
        child: Image.asset(
          url,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => placeholder,
        ),
      );
    }
    return SizedBox(
      width: w,
      height: h,
      child: CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        placeholder: (_, _) => placeholder,
        errorWidget: (_, _, _) => placeholder,
      ),
    );
  }
}
