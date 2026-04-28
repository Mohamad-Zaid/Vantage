import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vantage/core/theme/app_spacing.dart';
import 'package:vantage/core/theme/vantage_colors.dart';

import '../../domain/entities/order_detail_entity.dart';

class OrderDetailTimelineSection extends StatelessWidget {
  const OrderDetailTimelineSection({
    super.key,
    required this.detail,
    required this.isDark,
  });

  final OrderDetailEntity detail;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final steps = detail.timeline;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.inset28),
          _TimelineRow(
            title: steps[i].titleKey.tr(),
            dateText: steps[i].dateText,
            isComplete: steps[i].isComplete,
            isDark: isDark,
          ),
        ],
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.title,
    required this.dateText,
    required this.isComplete,
    required this.isDark,
  });

  final String title;
  final String dateText;
  final bool isComplete;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final activeTitle = isDark
        ? Colors.white
        : VantageColors.homeCategoryLabelLight;
    final inactiveTitle = isDark
        ? Colors.white.withValues(alpha: 0.5)
        : const Color(0x7F272727);
    final titleStyleColor = isComplete ? activeTitle : inactiveTitle;

    final pendingCircleBg = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : VantageColors.primaryTintLight;
    final completeCircleBg = VantageColors.authPrimaryPurple;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isComplete ? completeCircleBg : pendingCircleBg,
            shape: BoxShape.circle,
          ),
          child: isComplete
              ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
              : null,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.nunitoSans(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: titleStyleColor,
            ),
          ),
        ),
        Text(
          dateText,
          textAlign: TextAlign.right,
          style: GoogleFonts.nunitoSans(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.6,
            color: titleStyleColor,
          ),
        ),
      ],
    );
  }
}
