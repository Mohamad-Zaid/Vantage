import 'package:easy_localization/easy_localization.dart';

import 'package:vantage/core/translations/locale_keys.g.dart';

String trProductDetailColorName(String localeSuffix) {
  return switch (localeSuffix) {
    'Orange' => LocaleKeys.productDetail_colorOrange.tr(),
    'Black' => LocaleKeys.productDetail_colorBlack.tr(),
    'Red' => LocaleKeys.productDetail_colorRed.tr(),
    'Yellow' => LocaleKeys.productDetail_colorYellow.tr(),
    'Blue' => LocaleKeys.productDetail_colorBlue.tr(),
    'Lemon' => LocaleKeys.productDetail_colorLemon.tr(),
    _ => localeSuffix,
  };
}
