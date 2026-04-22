import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderDetailShippingCard extends StatelessWidget {
  const OrderDetailShippingCard({
    super.key,
    required this.address,
    required this.phone,
    required this.cardBg,
    required this.textColor,
  });

  final String address;
  final String phone;
  final Color cardBg;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: cardBg,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(11, 11, 11, 11),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              address,
              style: GoogleFonts.nunitoSans(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.6,
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              phone,
              style: GoogleFonts.nunitoSans(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.6,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
