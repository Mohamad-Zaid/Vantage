import 'package:flutter/material.dart';

import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/widgets/vantage_loading_indicator.dart';

class VantagePrimaryButton extends StatelessWidget {
  const VantagePrimaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.child,
    this.isLoading = false,
    this.height = 48,
    this.horizontalPadding = 48.6,
  });

  final VoidCallback? onPressed;
  final String label;

  // When non-null, replaces [label] (e.g. custom row content).
  final Widget? child;
  final bool isLoading;
  final double height;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: VantageColors.authPrimaryPurple,
          foregroundColor: Colors.white,
          disabledBackgroundColor:
              VantageColors.authPrimaryPurple.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 11,
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.67,
            letterSpacing: -0.5,
          ),
        ),
        child: isLoading
            ? const VantageLoadingIndicator.onPrimary()
            : (child ?? Text(label)),
      ),
    );
  }
}
