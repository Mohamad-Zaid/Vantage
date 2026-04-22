import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:vantage/core/theme/vantage_colors.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, required this.photoUrl});

  final String? photoUrl;

  static const double diameter = 80;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final placeholderBg =
        isDark ? VantageColors.authBgDark2 : VantageColors.homeAudiencePillLight;
    final iconColor =
        isDark ? Colors.white54 : VantageColors.homeCategoryLabelLight;

    return ClipOval(
      child: SizedBox(
        width: diameter,
        height: diameter,
        child: photoUrl != null && photoUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: photoUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => ColoredBox(color: placeholderBg),
                errorWidget: (context, url, error) => ColoredBox(
                  color: placeholderBg,
                  child: Icon(Icons.person, size: 40, color: iconColor),
                ),
              )
            : ColoredBox(
                color: placeholderBg,
                child: Icon(Icons.person, size: 40, color: iconColor),
              ),
      ),
    );
  }
}
