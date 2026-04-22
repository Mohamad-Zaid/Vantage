import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vantage/core/translations/locale_keys.g.dart';

class OrderDetailNavBar extends StatelessWidget {
  const OrderDetailNavBar({
    super.key,
    required this.displayNumber,
    required this.titleColor,
    required this.buttonBg,
    required this.iconColor,
  });

  final String displayNumber;
  final Color titleColor;
  final Color buttonBg;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 16),
      child: Row(
        children: [
          Material(
            color: buttonBg,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => context.router.maybePop(),
              customBorder: const CircleBorder(),
              child: SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16,
                  color: iconColor,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              LocaleKeys.orders_orderLine.tr(
                namedArgs: {'number': displayNumber},
              ),
              textAlign: TextAlign.center,
              style: GoogleFonts.gabarito(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: titleColor,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}
