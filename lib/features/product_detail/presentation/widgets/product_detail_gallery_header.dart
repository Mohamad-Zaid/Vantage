import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:vantage/core/domain/entities/product_entity.dart';
import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/widgets/vantage_circle_back_button.dart';

class ProductDetailGalleryHeader extends StatelessWidget {
  const ProductDetailGalleryHeader({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onBack,
    required this.onFavoriteTap,
  });

  final ProductEntity product;
  final bool isFavorite;
  final VoidCallback onBack;
  final VoidCallback onFavoriteTap;

  static const double _imageWidth = 161;
  static const double _imageHeight = 248;
  static const double _gap = 12;

  @override
  Widget build(BuildContext context) {
    final urls = List<String>.filled(3, product.imageUrl);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 25, 16, 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              VantageCircleBackButton(onPressed: onBack),
              _FavoriteCircleButton(
                isFavorite: isFavorite,
                onTap: onFavoriteTap,
              ),
            ],
          ),
        ),
        SizedBox(
          height: _imageHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: urls.length,
            separatorBuilder: (_, _) => const SizedBox(width: _gap),
            itemBuilder: (context, i) {
              return SizedBox(
                width: _imageWidth,
                height: _imageHeight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: _GalleryImage(url: urls[i]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FavoriteCircleButton extends StatelessWidget {
  const _FavoriteCircleButton({
    required this.isFavorite,
    required this.onTap,
  });

  final bool isFavorite;
  final VoidCallback onTap;

  static const double _outer = 40;
  static const double _icon = 22;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final purple = VantageColors.authPrimaryPurple;
    final wishlistFillInactive =
        isDark ? const Color(0xFF3A3548) : Colors.white;
    final wishlistCircleFill = isFavorite ? purple : wishlistFillInactive;
    final wishlistIconColor = isFavorite ? Colors.white : purple;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: _outer,
          height: _outer,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: wishlistCircleFill,
            border: Border.all(color: purple, width: 1.5),
          ),
          child: Center(
            child: Icon(
              isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              size: _icon,
              color: wishlistIconColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _GalleryImage extends StatelessWidget {
  const _GalleryImage({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final placeholderBg =
        isDark ? const Color(0xFF45405A) : const Color(0xFFE3F2F7);

    if (url.startsWith('assets/')) {
      return Image.asset(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, _, _) => Icon(
          Icons.image_not_supported_outlined,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      placeholder: (context, _) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ColoredBox(color: placeholderBg),
      ),
      errorWidget: (context, url, error) => Icon(
        Icons.image_not_supported_outlined,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
