import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderDetailSectionTitle extends StatelessWidget {
  const OrderDetailSectionTitle({
    super.key,
    required this.titleKey,
    required this.color,
  });

  final String titleKey;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      titleKey.tr(),
      style: GoogleFonts.gabarito(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: color,
      ),
    );
  }
}
