import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vantage/generated/assets.dart';
import 'package:vantage/core/theme/app_spacing.dart';

class NotificationRowCard extends StatelessWidget {
  const NotificationRowCard({
    super.key,
    required this.message,
    required this.cardBg,
    required this.iconColor,
    required this.bodyColor,
  });

  final String message;
  final Color cardBg;
  final Color iconColor;
  final Color bodyColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: cardBg,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: Center(
                child: SvgPicture.asset(
                  Assets.vectorNotification,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.inset21),
            Expanded(
              child: Text(
                message,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunitoSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.6,
                  color: bodyColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
