import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:vantage/core/theme/vantage_colors.dart';

// Shown while cold-start session resolution may route past sign-in.
class SignInColdStartSkeleton extends StatelessWidget {
  const SignInColdStartSkeleton({super.key});

  static const double _hPad = 24;
  static const double _titleToFormGap = 32;
  static const double _fieldGap = 16;
  static const double _fieldHeight = 56;

  @override
  Widget build(BuildContext context) {
    const base = VantageColors.authBgDark2;
    const highlight = Color(0xFF4A4458);
    const fill = VantageColors.authBgDark2;

    Widget bar({
      double? width,
      double height = 20,
      double radius = 4,
      bool fullWidth = false,
    }) {
      return Shimmer.fromColors(
        baseColor: base,
        highlightColor: highlight,
        child: Container(
          width: fullWidth ? double.infinity : width,
          height: height,
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: VantageColors.authBgDark1,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: _hPad),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              bar(height: 200, radius: 8, fullWidth: true),
              const SizedBox(height: _titleToFormGap),
              bar(width: 200, height: 32, radius: 6),
              const SizedBox(height: _fieldGap),
              bar(height: _fieldHeight, radius: 4, fullWidth: true),
              const SizedBox(height: _fieldGap),
              bar(height: _fieldHeight, radius: 4, fullWidth: true),
              const SizedBox(height: _fieldGap),
              bar(height: _fieldHeight, radius: 100, fullWidth: true),
            ],
          ),
        ),
      ),
    );
  }
}
