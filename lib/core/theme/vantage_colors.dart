import 'package:flutter/material.dart';

// Material color scheme and product-specific surfaces; change here to reskin the app.
abstract final class VantageColors {
  VantageColors._();

  static const Color primary = Color(0xFF6750A4);
  static const Color primaryContainer = Color(0xFFEADDFF);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF21005D);

  static const Color secondary = Color(0xFF625B71);
  static const Color secondaryContainer = Color(0xFFE8DEF8);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF1D192B);

  static const Color tertiary = Color(0xFF7D5260);
  static const Color tertiaryContainer = Color(0xFFFFD8E4);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color onTertiaryContainer = Color(0xFF31111D);

  static const Color error = Color(0xFFB3261E);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFF9DEDC);
  static const Color onErrorContainer = Color(0xFF410E0B);

  static const Color surface = Color(0xFFFFFBFE);
  static const Color onSurface = Color(0xFF1C1B1F);
  static const Color surfaceContainerHighest = Color(0xFFE6E1E5);
  static const Color onSurfaceVariant = Color(0xFF49454F);

  static const Color outline = Color(0xFF79747E);
  static const Color outlineVariant = Color(0xFFCAC4D0);

  static const Color authBgDark1 = Color(0xFF1D182A);
  static const Color authBgDark2 = Color(0xFF342F3F);
  static const Color authPrimaryPurple = Color(0xFF8E6CEE);

  static const Color primaryTintLight = Color(0xFFEEE9F5);

  static const Color bottomNavLightBg = Color(0xFFFFFFFF);
  static const Color bottomNavLightIconActive = Color(0xFF8A72F1);
  static const Color bottomNavLightIconInactive = Color(0xFF9E9E9E);

  static const Color bottomNavDarkBg = Color(0xFF1A1A2E);

  static Color scaffoldBackground(Brightness brightness) {
    return brightness == Brightness.dark
        ? bottomNavDarkBg
        : bottomNavLightBg;
  }

  static const Color homeCategoryLabelLight = Color(0xFF272727);

  static const Color homeAudiencePillLight = Color(0xFFF4F4F4);

  static const Color profileTextSecondaryLight = Color(0x7F272727);

  static const Color profileSignOutRed = Color(0xFFFA3636);

  static const Color homeSearchFieldLight = Color(0xFFF4F4F4);

  static const Color authFieldError = Color(0xFFFF8A80);

  static ColorScheme get light => ColorScheme.light(
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        onSecondary: onSecondary,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer,
        tertiary: tertiary,
        onTertiary: onTertiary,
        tertiaryContainer: tertiaryContainer,
        onTertiaryContainer: onTertiaryContainer,
        error: error,
        onError: onError,
        errorContainer: errorContainer,
        onErrorContainer: onErrorContainer,
        surface: surface,
        onSurface: onSurface,
        surfaceContainerHighest: surfaceContainerHighest,
        onSurfaceVariant: onSurfaceVariant,
        outline: outline,
        outlineVariant: outlineVariant,
      );

  static ColorScheme get dark => ColorScheme.dark(
        primary: const Color(0xFFD0BCFF),
        onPrimary: const Color(0xFF381E72),
        primaryContainer: const Color(0xFF4F378B),
        onPrimaryContainer: const Color(0xFFEADDFF),
        secondary: const Color(0xFFCCC2DC),
        onSecondary: const Color(0xFF332D41),
        secondaryContainer: const Color(0xFF4A4458),
        onSecondaryContainer: const Color(0xFFE8DEF8),
        tertiary: const Color(0xFFEFB8C8),
        onTertiary: const Color(0xFF492532),
        tertiaryContainer: const Color(0xFF633B48),
        onTertiaryContainer: const Color(0xFFFFD8E4),
        error: const Color(0xFFF2B8B5),
        onError: const Color(0xFF601410),
        errorContainer: const Color(0xFF8C1D18),
        onErrorContainer: const Color(0xFFF9DEDC),
        surface: const Color(0xFF1C1B1F),
        onSurface: const Color(0xFFE6E1E5),
        surfaceContainerHighest: const Color(0xFF49454F),
        onSurfaceVariant: const Color(0xFFCAC4D0),
        outline: const Color(0xFF938F99),
        outlineVariant: const Color(0xFF49454F),
      );
}
