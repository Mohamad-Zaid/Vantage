import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import 'package:vantage/core/domain/entities/product_entity.dart';
import 'package:vantage/core/theme/vantage_colors.dart';

// Shared height constants keep shelves, carousels, and grids aligned so rows don’t jump between contexts.
class VantageProductCard extends StatelessWidget {
  const VantageProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onFavoriteTap,
    this.isFavorite = false,
  });

  final ProductEntity product;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  final bool isFavorite;

  static const double _imageHeight = 190;
  static const double shelfImageHeight = _imageHeight;

  static const double _detailsSlotMax = 122;
  static const double _radius = 12;
  static const double _favOuter = 40;
  static const double _favIcon = 22;

  static const double cardFixedHeight = _imageHeight + _detailsSlotMax;

  static const double shelfCrossAxisExtent = cardFixedHeight;

  static const double gridMainAxisExtent = cardFixedHeight;

  static const Color _saleRed = Color(0xFFE53935);
  static const Color _starColor = Color(0xFFFFC107);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final detailsBg = isDark ? VantageColors.authBgDark2 : Colors.white;
    final titleColor = isDark
        ? Colors.white
        : VantageColors.homeCategoryLabelLight;
    final muted = isDark
        ? Colors.white.withValues(alpha: 0.55)
        : VantageColors.homeCategoryLabelLight.withValues(alpha: 0.55);
    final purple = VantageColors.authPrimaryPurple;
    final salePct = product.saleDiscountPercent;
    final imageAreaBg = isDark
        ? const Color(0xFF45405A)
        : const Color(0xFFE3F2F7);

    final wishlistFillInactive = isDark ? const Color(0xFF3A3548) : Colors.white;
    final wishlistBorder = purple;
    final wishlistCircleFill = isFavorite ? purple : wishlistFillInactive;
    final wishlistIconColor = isFavorite ? Colors.white : purple;

    return SizedBox(
      height: cardFixedHeight,
      child: Material(
        color: detailsBg,
        borderRadius: BorderRadius.circular(_radius),
        clipBehavior: Clip.antiAlias,
        elevation: isDark ? 0 : 1,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(_radius),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: _imageHeight,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(_radius),
                      ),
                      child: SizedBox(
                        height: _imageHeight,
                        width: double.infinity,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ColoredBox(color: imageAreaBg),
                            _ProductImageLayer(
                              imageUrl: product.imageUrl,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: onFavoriteTap,
                                  customBorder: const CircleBorder(),
                                  child: Container(
                                    width: _favOuter,
                                    height: _favOuter,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: wishlistCircleFill,
                                      border: Border.all(
                                        color: wishlistBorder,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        isFavorite
                                            ? Icons.favorite_rounded
                                            : Icons.favorite_border_rounded,
                                        size: _favIcon,
                                        color: wishlistIconColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (salePct != null)
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 7,
                          ),
                          decoration: const BoxDecoration(
                            color: _saleRed,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                          child: Text(
                            '-$salePct%',
                            style: GoogleFonts.gabarito(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.gabarito(
                                color: titleColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              product.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.nunitoSans(
                                color: muted,
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              _categoryLabel(product.categoryId),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.nunitoSans(
                                color: purple,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: GoogleFonts.gabarito(
                                    color: isDark ? titleColor : purple,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    height: 1.1,
                                  ),
                                ),
                                if (product.compareAtPrice != null &&
                                    product.compareAtPrice! >
                                        product.price) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    '\$${product.compareAtPrice!.toStringAsFixed(2)}',
                                    style: GoogleFonts.nunitoSans(
                                      color: muted,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: muted,
                                      height: 1.2,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 1),
                            child: Icon(
                              Icons.star_rounded,
                              size: 17,
                              color: _starColor,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '(${product.rating.toStringAsFixed(1)})',
                            style: GoogleFonts.nunitoSans(
                              color: muted,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _categoryLabel(String categoryId) {
  const map = {
    'cat_hoodies': 'Hoodies',
    'cat_shorts': 'Shorts',
    'cat_shoes': 'Shoes',
    'cat_bags': 'Bags',
    'cat_accessories': 'Accessories',
  };
  if (map.containsKey(categoryId)) return map[categoryId]!;
  final tail = categoryId.replaceFirst(RegExp(r'^cat_'), '');
  if (tail.isEmpty) return categoryId;
  return tail[0].toUpperCase() + tail.substring(1);
}

extension ProductEntitySaleX on ProductEntity {
  int? get saleDiscountPercent {
    final original = compareAtPrice;
    if (original == null || original <= price) return null;
    final pct = (((original - price) / original) * 100).round();
    if (pct <= 0) return null;
    return pct.clamp(1, 99);
  }
}

class _ProductImageLayer extends StatelessWidget {
  const _ProductImageLayer({required this.imageUrl, this.fit = BoxFit.cover});

  final String imageUrl;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        fit: fit,
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        errorBuilder: (_, _, _) => Icon(
          Icons.image_not_supported_outlined,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(color: Colors.white),
      ),
      errorWidget: (context, url, error) => Icon(
        Icons.image_not_supported_outlined,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
