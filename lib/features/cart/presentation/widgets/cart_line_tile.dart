import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vantage/core/theme/app_spacing.dart';
import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/features/cart/domain/entities/cart_line_entity.dart';
import 'package:vantage/features/cart/presentation/widgets/cart_money.dart';

class CartLineTile extends StatelessWidget {
  const CartLineTile({
    super.key,
    required this.line,
    required this.onDecrement,
    required this.onIncrement,
  });

  final CartLineEntity line;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark
        ? VantageColors.authBgDark2
        : VantageColors.homeAudiencePillLight;
    final titleC =
        isDark ? Colors.white : VantageColors.homeCategoryLabelLight;
    final subC = isDark
        ? Colors.white.withValues(alpha: 0.55)
        : VantageColors.profileTextSecondaryLight;
    final purple = VantageColors.authPrimaryPurple;

    return Material(
      color: cardBg,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _Thumb(url: line.imageUrl),
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
                      color: titleC,
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
                      color: subC,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    LocaleKeys.cart_lineColor.tr(
                      namedArgs: {'color': line.colorLabel},
                    ),
                    style: GoogleFonts.nunitoSans(
                      color: subC,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        CartMoney.usd(line.unitPrice * line.quantity),
                        style: GoogleFonts.gabarito(
                          color: purple,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _StepBtn(
                              color: purple,
                              icon: Icons.remove_rounded,
                              onPressed: onDecrement,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                '${line.quantity}',
                                style: GoogleFonts.nunitoSans(
                                  color: titleC,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            _StepBtn(
                              color: purple,
                              icon: Icons.add_rounded,
                              onPressed: onIncrement,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepBtn extends StatelessWidget {
  const _StepBtn({
    required this.color,
    required this.icon,
    required this.onPressed,
  });

  final Color color;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 32,
          height: 32,
          child: Icon(icon, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    const w = 64.0;
    const h = 72.0;
    if (url.startsWith('assets/')) {
      return Image.asset(
        url,
        width: w,
        height: h,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => const ColoredBox(
          color: Color(0xFFE0E0E0),
          child: Center(child: Icon(Icons.image_not_supported_outlined)),
        ),
      );
    }
    return CachedNetworkImage(
      imageUrl: url,
      width: w,
      height: h,
      fit: BoxFit.cover,
    );
  }
}
