import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:vantage/generated/assets.dart';

// LTR asset mirrored in RTL so “forward” stays semantically forward for Arabic.
class DirectionalArrowIcon extends StatelessWidget {
  const DirectionalArrowIcon({super.key, required this.color, this.size = 24});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return Transform.flip(
      flipX: rtl,
      child: SvgPicture.asset(
        Assets.vectorArrowRight,
        width: size,
        height: size,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
}
