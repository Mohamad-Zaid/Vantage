import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vantage/core/domain/entities/product_entity.dart';
import 'package:vantage/router/app_router.dart';
import 'package:vantage/core/widgets/vantage_product_card.dart';
import 'package:vantage/features/wishlist/presentation/cubit/favorites_cubit.dart';
import 'package:vantage/features/wishlist/presentation/cubit/favorites_state.dart';

class HomeProductCarousel extends StatelessWidget {
  const HomeProductCarousel({
    super.key,
    required this.products,
    this.horizontalPadding = 24,
  });

  final List<ProductEntity> products;

  final double horizontalPadding;

  static const double cardWidth = 159;
  static const double gap = 12;

  static double get rowHeight => VantageProductCard.shelfCrossAxisExtent;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    return BlocBuilder<FavoritesCubit, FavoritesState>(
      buildWhen: (p, c) =>
          c is FavoritesLoaded ||
          c is FavoritesLoading ||
          c is FavoritesInitial,
      builder: (context, favState) {
        final ids = favState is FavoritesLoaded
            ? favState.ids
            : <String>{};
        return SizedBox(
          height: rowHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding:
                EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 0),
            clipBehavior: Clip.none,
            itemCount: products.length,
            separatorBuilder: (_, _) => const SizedBox(width: gap),
            itemBuilder: (context, i) {
              final product = products[i];
              return Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: cardWidth,
                  child: VantageProductCard(
                    product: product,
                    onTap: () => context.router.push(
                      ProductDetailRoute(product: product),
                    ),
                    isFavorite: ids.contains(product.id),
                    onFavoriteTap: () => context
                        .read<FavoritesCubit>()
                        .toggleFavorite(product),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}