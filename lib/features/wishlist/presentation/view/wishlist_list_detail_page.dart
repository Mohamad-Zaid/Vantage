import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vantage/core/theme/app_spacing.dart';
import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/core/widgets/vantage_circle_back_button.dart';
import 'package:vantage/core/widgets/vantage_loading_indicator.dart';
import 'package:vantage/core/widgets/vantage_product_card.dart';
import 'package:vantage/router/app_router.dart';

import '../cubit/favorites_cubit.dart';
import '../cubit/favorites_state.dart';

@RoutePage()
class WishlistListDetailPage extends StatelessWidget {
  const WishlistListDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor =
        isDark ? Colors.white : VantageColors.homeCategoryLabelLight;
    final muted = isDark
        ? Colors.white.withValues(alpha: 0.55)
        : VantageColors.homeCategoryLabelLight.withValues(alpha: 0.55);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenHorizontal,
                AppSpacing.sm,
                AppSpacing.screenHorizontal,
                0,
              ),
              child: Row(
                children: [
                  VantageCircleBackButton(
                    onPressed: () => context.router.maybePop(),
                  ),
                  Expanded(
                    child: BlocBuilder<FavoritesCubit, FavoritesState>(
                      buildWhen: (previous, current) =>
                          current is FavoritesLoaded ||
                          current is FavoritesLoading ||
                          current is FavoritesError,
                      builder: (context, state) {
                        final count = switch (state) {
                          FavoritesLoaded(:final products) => products.length,
                          _ => 0,
                        };
                        final title = LocaleKeys.wishlist_myFavouritesWithCount
                            .tr(namedArgs: {'count': '$count'});
                        return Text(
                          title,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.gabarito(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: titleColor,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.toolbarIconSlot),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Expanded(
              child: BlocBuilder<FavoritesCubit, FavoritesState>(
                builder: (context, state) {
                  return switch (state) {
                    FavoritesLoading() || FavoritesInitial() => const Center(
                        child: VantageLoadingIndicator(),
                      ),
                    FavoritesError(:final message) => RefreshIndicator(
                        onRefresh: () =>
                            context.read<FavoritesCubit>().refresh(),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.3,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.screenHorizontal,
                                ),
                                child: Text(
                                  '${LocaleKeys.common_error.tr()}\n$message',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: titleColor),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    FavoritesLoaded(:final products)
                        when products.isEmpty =>
                      RefreshIndicator(
                        onRefresh: () =>
                            context.read<FavoritesCubit>().refresh(),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.5,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                ),
                                child: Text(
                                  LocaleKeys.wishlist_empty.tr(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: muted,
                                    fontSize: 15,
                                    height: 1.35,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    FavoritesLoaded(
                      :final products,
                      :final hasMore,
                      :final isLoadingMore,
                    ) =>
                      NotificationListener<ScrollNotification>(
                        onNotification: (n) {
                          if (n is! ScrollUpdateNotification) {
                            return false;
                          }
                          final metrics = n.metrics;
                          if (metrics.pixels < metrics.maxScrollExtent - 160) {
                            return false;
                          }
                          if (!hasMore || isLoadingMore) {
                            return false;
                          }
                          unawaited(
                            context.read<FavoritesCubit>().loadMore(),
                          );
                          return false;
                        },
                        child: RefreshIndicator(
                          onRefresh: () =>
                              context.read<FavoritesCubit>().refresh(),
                          child: CustomScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            slivers: [
                              SliverPadding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.screenHorizontal,
                                ),
                                sliver: SliverGrid(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: AppSpacing.inset20,
                                    crossAxisSpacing: AppSpacing.inset20,
                                    mainAxisExtent:
                                        VantageProductCard.gridMainAxisExtent,
                                  ),
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      final product = products[index];
                                      return VantageProductCard(
                                        product: product,
                                        onTap: () => context.router.push(
                                          ProductDetailRoute(
                                            product: product,
                                          ),
                                        ),
                                        isFavorite: true,
                                        onFavoriteTap: () => context
                                            .read<FavoritesCubit>()
                                            .toggleFavorite(product),
                                      );
                                    },
                                    childCount: products.length,
                                  ),
                                ),
                              ),
                              if (isLoadingMore)
                                const SliverToBoxAdapter(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: AppSpacing.inset20,
                                    ),
                                    child: Center(
                                      child: VantageLoadingIndicator(
                                        size: AppSpacing.xl,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    _ => Center(
                        child: Text(
                          LocaleKeys.wishlist_empty.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: muted),
                        ),
                      ),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
