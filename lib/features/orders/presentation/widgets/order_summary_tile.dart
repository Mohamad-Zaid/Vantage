import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/core/widgets/directional_arrow_icon.dart';
import 'package:vantage/generated/assets.dart';

import '../../domain/entities/order_summary_entity.dart';

class OrderSummaryTile extends StatelessWidget {
  const OrderSummaryTile({
    super.key,
    required this.order,
    required this.cardBg,
    required this.titleColor,
    required this.subtitleColor,
    required this.onTap,
  });

  final OrderSummaryEntity order;
  final Color cardBg;
  final Color titleColor;
  final Color subtitleColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: cardBg,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Row(
            children: [
              SizedBox(
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
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      LocaleKeys.orders_orderLine.tr(
                        namedArgs: {'number': order.displayNumber},
                      ),
                      style: GoogleFonts.nunitoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      LocaleKeys.orders_itemsCount.tr(
                        namedArgs: {'count': '${order.itemCount}'},
                      ),
                      style: GoogleFonts.nunitoSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 1.6,
                        color: subtitleColor,
                      ),
                    ),
                  ],
                ),
              ),
              DirectionalArrowIcon(color: titleColor, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
