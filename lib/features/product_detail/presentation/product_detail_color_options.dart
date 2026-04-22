import 'package:flutter/material.dart';

import 'package:vantage/core/theme/vantage_colors.dart';

abstract final class ProductDetailColorOptions {
  ProductDetailColorOptions._();

  // [localeSuffix] lines up with [LocaleKeys.productDetail_color*].
  static const List<({String localeSuffix, Color swatch})> options = [
    (localeSuffix: 'Orange', swatch: Color(0xFFEC6D26)),
    (localeSuffix: 'Black', swatch: VantageColors.homeCategoryLabelLight),
    (localeSuffix: 'Red', swatch: VantageColors.profileSignOutRed),
    (localeSuffix: 'Yellow', swatch: Color(0xFFF4BD2F)),
    (localeSuffix: 'Blue', swatch: Color(0xFF4468E5)),
    (localeSuffix: 'Lemon', swatch: Color(0xFFB3B68B)),
  ];
}
