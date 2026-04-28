import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';

import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';
import 'package:vantage/core/widgets/home_shelves_loading_shimmer.dart';

import 'home_product_carousel.dart';
import 'home_section_header.dart';
import 'package:vantage/core/theme/app_spacing.dart';

class HomeShelvesSection extends StatelessWidget {
  const HomeShelvesSection({super.key, required this.productCubit});

  final ProductCubit productCubit;

  static const double _hPad = 24;
  static const double _headerToCarousel = 10;
  static const double _sectionGapAboveHeader = 24;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      bloc: productCubit,
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return switch (state) {
          ProductInitial() => const SizedBox.shrink(),
          ProductLoading() => const HomeShelvesLoadingShimmer(),
          ProductEmpty() => Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: _hPad,
            ),
            child: Center(child: Text(LocaleKeys.home_emptyProducts.tr())),
          ),
          ProductLoaded(:final topSelling, :final newInByCategory) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: _hPad),
                child: HomeSectionHeader(titleKey: LocaleKeys.home_topSelling),
              ),
              const SizedBox(height: _headerToCarousel),
              HomeProductCarousel(products: topSelling),
              for (final shelf in newInByCategory)
                if (shelf.products.isNotEmpty) ...[
                  const SizedBox(height: _sectionGapAboveHeader),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: _hPad),
                    child: HomeSectionHeader(
                      titleKey: shelf.titleKey,
                      accentTitle: true,
                    ),
                  ),
                  const SizedBox(height: _headerToCarousel),
                  HomeProductCarousel(products: shelf.products),
                ],
              const SizedBox(height: AppSpacing.xs),
            ],
          ),
          ProductError(:final message) => Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(LocaleKeys.common_error.tr()),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                FilledButton(
                  onPressed: productCubit.loadProducts,
                  child: Text(LocaleKeys.common_retry.tr()),
                ),
              ],
            ),
          ),
        };
      },
    );
  }
}
