import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vantage/core/catalog/shop_categories_catalog.dart';
import 'package:vantage/core/domain/entities/product_entity.dart';
import 'package:vantage/core/theme/app_spacing.dart';
import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/core/widgets/vantage_primary_button.dart';
import 'package:vantage/core/widgets/vantage_product_card.dart';
import 'package:vantage/core/widgets/vantage_success_burst_overlay.dart';
import 'package:vantage/features/product_detail/presentation/cubit/product_detail_cubit.dart';
import 'package:vantage/features/product_detail/presentation/cubit/product_detail_state.dart';
import 'package:vantage/features/product_detail/presentation/product_detail_color_options.dart';
import 'package:vantage/features/product_detail/presentation/widgets/product_detail_color_sheet.dart';
import 'package:vantage/features/product_detail/presentation/widgets/product_detail_gallery_header.dart';
import 'package:vantage/features/product_detail/presentation/widgets/product_detail_option_row.dart';
import 'package:vantage/features/product_detail/presentation/widgets/product_detail_quantity_row.dart';
import 'package:vantage/features/product_detail/presentation/widgets/product_detail_size_sheet.dart';
import 'package:vantage/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:vantage/features/wishlist/presentation/cubit/favorites_cubit.dart';
import 'package:vantage/features/wishlist/presentation/cubit/favorites_state.dart';

@RoutePage()
class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key, required this.product});

  final ProductEntity product;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final GlobalKey _addToBagKey = GlobalKey();
  late final ProductDetailCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = ProductDetailCubit(widget.product);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  String _formatUsd(double price) {
    final frac = price - price.truncateToDouble();
    if (frac.abs() < 0.001) {
      return '\$${price.toStringAsFixed(0)}';
    }
    return '\$${price.toStringAsFixed(2)}';
  }

  // Overlay-local when the sticky CTA/overlay can’t provide a [RenderBox] yet.
  Offset _fallbackAddToBagAnchor(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return Offset(
      screenSize.width / 2,
      screenSize.height - AppSpacing.toolbarIconSlot,
    );
  }

  String _categoryLabel(String categoryId) {
    final key = categoryTitleKeyForId(categoryId);
    if (key != null) return key.tr();
    final tail = categoryId.replaceFirst(RegExp(r'^cat_'), '');
    if (tail.isEmpty) return categoryId;
    return tail[0].toUpperCase() + tail.substring(1);
  }

  String _localizedColorName(int colorIndex) {
    final opts = ProductDetailColorOptions.options;
    final safeColorIndex = colorIndex.clamp(0, opts.length - 1);
    return switch (opts[safeColorIndex].localeSuffix) {
      'Orange' => LocaleKeys.productDetail_colorOrange.tr(),
      'Black' => LocaleKeys.productDetail_colorBlack.tr(),
      'Red' => LocaleKeys.productDetail_colorRed.tr(),
      'Yellow' => LocaleKeys.productDetail_colorYellow.tr(),
      'Blue' => LocaleKeys.productDetail_colorBlue.tr(),
      'Lemon' => LocaleKeys.productDetail_colorLemon.tr(),
      _ => opts[safeColorIndex].localeSuffix,
    };
  }

  void _openSizeSheet(BuildContext context, ProductDetailReady state) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      barrierColor: VantageColors.homeCategoryLabelLight.withValues(alpha: 0.5),
      backgroundColor: Colors.transparent,
      builder: (_) => ProductDetailSizeSheet(
        sizes: ProductDetailCubit.kSizes.toList(),
        selected: state.selectedSize,
        onSelect: _cubit.selectSize,
      ),
    );
  }

  void _openColorSheet(BuildContext context, ProductDetailReady state) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      barrierColor: VantageColors.homeCategoryLabelLight.withValues(alpha: 0.5),
      backgroundColor: Colors.transparent,
      builder: (_) => ProductDetailColorSheet(
        selectedIndex: state.selectedColorIndex,
        onSelect: _cubit.selectColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailCubit, ProductDetailState>(
      bloc: _cubit,
      buildWhen: (p, c) => p != c,
      builder: (context, state) {
        return switch (state) {
          ProductDetailReady() => _buildReady(context, state),
        };
      },
    );
  }

  Widget _buildReady(BuildContext context, ProductDetailReady state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark
        ? Colors.white
        : VantageColors.homeCategoryLabelLight;
    final bodyMuted = isDark
        ? Colors.white.withValues(alpha: 0.55)
        : VantageColors.profileTextSecondaryLight;
    final purple = VantageColors.authPrimaryPurple;
    const starColor = Color(0xFFFFC107);

    final product = state.product;
    final salePct = product.saleDiscountPercent;
    final onSale =
        product.compareAtPrice != null &&
        product.compareAtPrice! > product.price;
    final colorOpts = ProductDetailColorOptions.options;
    final idx = state.selectedColorIndex.clamp(0, colorOpts.length - 1);
    final swatch = colorOpts[idx].swatch;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: BlocBuilder<FavoritesCubit, FavoritesState>(
                      buildWhen: (p, c) =>
                          c is FavoritesLoaded ||
                          c is FavoritesLoading ||
                          c is FavoritesInitial,
                      builder: (context, favState) {
                        final ids = favState is FavoritesLoaded
                            ? favState.ids
                            : <String>{};
                        return ProductDetailGalleryHeader(
                          product: product,
                          isFavorite: ids.contains(product.id),
                          onBack: () => context.router.maybePop(),
                          onFavoriteTap: () => context
                              .read<FavoritesCubit>()
                              .toggleFavorite(product),
                        );
                      },
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        Text(
                          product.name,
                          style: GoogleFonts.gabarito(
                            color: titleColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.xs,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              _categoryLabel(product.categoryId),
                              style: GoogleFonts.nunitoSans(
                                color: purple,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  size: 18,
                                  color: starColor,
                                ),
                                const SizedBox(width: AppSpacing.xxs),
                                Text(
                                  LocaleKeys.productDetail_ratingReviewLine.tr(
                                    namedArgs: {
                                      'rating': product.rating.toStringAsFixed(1),
                                      'count': '120',
                                    },
                                  ),
                                  style: GoogleFonts.nunitoSans(
                                    color: bodyMuted,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                            if (onSale && salePct != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.inset10,
                                  vertical: AppSpacing.xxs,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE53935),
                                  borderRadius:
                                      BorderRadius.circular(AppSpacing.xs),
                                ),
                                child: Text(
                                  '-$salePct%',
                                  style: GoogleFonts.gabarito(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    height: 1,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          product.description,
                          style: GoogleFonts.nunitoSans(
                            color: bodyMuted,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              _formatUsd(product.price),
                              style: GoogleFonts.gabarito(
                                color: purple,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                height: 1.25,
                              ),
                            ),
                            if (onSale) ...[
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                _formatUsd(product.compareAtPrice!),
                                style: GoogleFonts.nunitoSans(
                                  color: bodyMuted,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.lineThrough,
                                  height: 1.25,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        ProductDetailOptionRow(
                          label: LocaleKeys.productDetail_size.tr(),
                          onTap: () => _openSizeSheet(context, state),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                state.selectedSize,
                                style: GoogleFonts.gabarito(
                                  color: titleColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: titleColor,
                                size: AppSpacing.xl,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        ProductDetailOptionRow(
                          label: LocaleKeys.productDetail_color.tr(),
                          onTap: () => _openColorSheet(context, state),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: swatch,
                                  border: Border.all(
                                    color: isDark
                                        ? Colors.white54
                                        : const Color(0xFFE0E0E0),
                                    width: 1,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: titleColor,
                                size: AppSpacing.xl,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        ProductDetailQuantityRow(
                          label: LocaleKeys.productDetail_quantity.tr(),
                          quantity: state.quantity,
                          onIncrement: _cubit.incrementQuantity,
                          onDecrement: _cubit.decrementQuantity,
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        Text(
                          LocaleKeys.productDetail_shippingReturns.tr(),
                          style: GoogleFonts.gabarito(
                            color: titleColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          LocaleKeys.productDetail_shippingReturnsBody.tr(),
                          style: GoogleFonts.nunitoSans(
                            color: bodyMuted,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.inset25),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenHorizontal,
                0,
                AppSpacing.screenHorizontal,
                AppSpacing.lg,
              ),
              child: VantagePrimaryButton(
                key: _addToBagKey,
                label: LocaleKeys.productDetail_addToBag.tr(),
                horizontalPadding: AppSpacing.screenHorizontal,
                onPressed: () async {
                  final cart = context.read<CartCubit>();
                  await cart.addProductLine(
                    productId: product.id,
                    name: product.name,
                    imageUrl: product.imageUrl,
                    unitPrice: product.price,
                    size: state.selectedSize,
                    colorLabel: _localizedColorName(idx),
                    quantity: state.quantity,
                  );
                  if (!mounted) return;
                  final origin = VantageSuccessBurstOverlay
                      .originInOverlayForButton(
                    this.context,
                    buttonKey: _addToBagKey,
                    fallback: _fallbackAddToBagAnchor(this.context),
                  );
                  if (!mounted) return;
                  VantageSuccessBurstOverlay.show(
                    this.context,
                    origin: origin,
                    onComplete: () {
                      if (this.context.mounted) {
                        Navigator.of(this.context).pop();
                      }
                    },
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatUsd(product.price),
                      style: GoogleFonts.gabarito(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      LocaleKeys.productDetail_addToBag.tr(),
                      style: GoogleFonts.nunitoSans(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
