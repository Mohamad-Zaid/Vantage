import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:vantage/core/widgets/home_shelves_loading_shimmer.dart';

// Home-shaped shell while cold start may still route to the main [NavigationPage].
class HomeColdStartSkeleton extends StatelessWidget {
  const HomeColdStartSkeleton({super.key});

  static const double _hPad = 24;
  static const double _avatar = 40;
  static const double _categoryCircle = 56;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? Colors.grey.shade800 : Colors.grey.shade400;
    final highlight = isDark ? Colors.grey.shade600 : Colors.grey.shade200;
    final fill = Theme.of(context).colorScheme.surfaceContainerHighest;

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
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(_hPad, 8, _hPad, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            bar(width: _avatar, height: _avatar, radius: 100),
                            Expanded(
                              child: Center(
                                child: bar(width: 132, height: 44, radius: 100),
                              ),
                            ),
                            bar(width: _avatar, height: _avatar, radius: 100),
                          ],
                        ),
                        const SizedBox(height: 12),
                        bar(height: 56, radius: 12, fullWidth: true),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            bar(width: 120, height: 18, radius: 4),
                            bar(width: 56, height: 18, radius: 4),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var i = 0; i < 5; i++)
                              Expanded(
                                child: Column(
                                  children: [
                                    Center(
                                      child: bar(
                                        width: _categoryCircle,
                                        height: _categoryCircle,
                                        radius: 100,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Center(
                                      child: bar(
                                        width: 40,
                                        height: 10,
                                        radius: 4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                  const HomeShelvesLoadingShimmer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
