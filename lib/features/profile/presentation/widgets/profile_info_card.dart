import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';

class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({
    super.key,
    required this.name,
    required this.email,
    this.phone,
    this.onEdit,
  });

  final String name;
  final String email;
  final String? phone;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg =
        isDark ? VantageColors.authBgDark2 : VantageColors.homeAudiencePillLight;
    final nameColor = isDark ? Colors.white : VantageColors.homeCategoryLabelLight;
    final secondaryColor = isDark
        ? Colors.white.withValues(alpha: 0.5)
        : VantageColors.profileTextSecondaryLight;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: ColoredBox(
        color: cardBg,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 13, 16, 13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: GoogleFonts.gabarito(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: nameColor,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      email,
                      style: GoogleFonts.nunitoSans(
                        fontSize: 16,
                        fontWeight: const FontWeight(450),
                        color: secondaryColor,
                      ),
                    ),
                  ),
                  if (onEdit != null) ...[
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: onEdit,
                      behavior: HitTestBehavior.opaque,
                      child: Text(
                        LocaleKeys.profile_edit.tr(),
                        style: GoogleFonts.gabarito(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: VantageColors.authPrimaryPurple,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              if (phone != null && phone!.trim().isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  phone!,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 16,
                    fontWeight: const FontWeight(450),
                    color: secondaryColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
