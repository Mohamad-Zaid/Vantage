import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:vantage/core/widgets/vantage_product_card.dart';

// Must match [HomeProductCarousel.cardWidth] or the shelf row width jumps.
const double kHomeShelfShimmerCardWidth = 159;

class HomeShelvesLoadingShimmer extends StatelessWidget {
  const HomeShelvesLoadingShimmer({super.key});

  static const double _hPad = 24;
  static const double _headerToCarousel = 10;
  static const double _sectionGapAboveHeader = 24;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: _hPad),
            child: const _HeaderShimmer(),
          ),
          const SizedBox(height: _headerToCarousel),
          const _CarouselShimmer(),
          ...List.generate(
            5,
            (i) => Column(
              key: ValueKey('shimmer_$i'),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: _sectionGapAboveHeader),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: _hPad),
                  child: _HeaderShimmer(),
                ),
                const SizedBox(height: _headerToCarousel),
                const _CarouselShimmer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderShimmer extends StatelessWidget {
  const _HeaderShimmer();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? Colors.grey.shade800 : Colors.grey.shade400;
    final highlight = isDark ? Colors.grey.shade600 : Colors.grey.shade200;
    final fill = Theme.of(context).colorScheme.surfaceContainerHighest;

    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: Container(
        height: 20,
        width: 200,
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

class _CarouselShimmer extends StatelessWidget {
  const _CarouselShimmer();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? Colors.grey.shade800 : Colors.grey.shade400;
    final highlight = isDark ? Colors.grey.shade600 : Colors.grey.shade200;
    final fill = Theme.of(context).colorScheme.surfaceContainerHighest;
    final rowH = VantageProductCard.shelfCrossAxisExtent;
    final imgH = VantageProductCard.shelfImageHeight;

    return SizedBox(
      height: rowH,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
        itemCount: 3,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, _) => Shimmer.fromColors(
          baseColor: base,
          highlightColor: highlight,
          child: Container(
            width: kHomeShelfShimmerCardWidth,
            height: rowH,
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(height: imgH, color: fill),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 12,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: fill,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: 10,
                          width: 100,
                          decoration: BoxDecoration(
                            color: fill,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          height: 12,
                          width: 72,
                          decoration: BoxDecoration(
                            color: fill,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
