import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Arabic: Cairo; Latin: Poppins.
abstract final class VantageTypography {
  VantageTypography._();

  static TextTheme textTheme(Locale locale, Brightness brightness) {
    final isArabic = locale.languageCode == 'ar';
    
    // M3 base [TextTheme] supplies on-surface colors; we only swap the font family.
    final baseTheme = brightness == Brightness.dark 
        ? ThemeData.dark(useMaterial3: true).textTheme 
        : ThemeData.light(useMaterial3: true).textTheme;

    return isArabic 
        ? GoogleFonts.cairoTextTheme(baseTheme) 
        : GoogleFonts.poppinsTextTheme(baseTheme);
  }
}
