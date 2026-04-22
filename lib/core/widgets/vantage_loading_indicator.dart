import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import 'package:vantage/core/theme/vantage_colors.dart';

class VantageLoadingIndicator extends StatelessWidget {
  const VantageLoadingIndicator({
    super.key,
    this.size = 48,
    List<Color>? colors,
    this.strokeWidth = 2,
    this.indicatorType = Indicator.ballBeat,
  }) : _colors = colors;

  // White on purple buttons (sufficient contrast on primary fill).
  const VantageLoadingIndicator.onPrimary({
    super.key,
    this.size = 24,
    this.strokeWidth = 2,
    this.indicatorType = Indicator.ballBeat,
  }) : _colors = const [Colors.white];

  final double size;
  final List<Color>? _colors;
  final double strokeWidth;
  final Indicator indicatorType;

  @override
  Widget build(BuildContext context) {
    final colors = _colors ?? [VantageColors.authPrimaryPurple];
    return SizedBox(
      width: size,
      height: size,
      child: LoadingIndicator(
        indicatorType: indicatorType,
        colors: colors,
        strokeWidth: strokeWidth,
      ),
    );
  }
}
