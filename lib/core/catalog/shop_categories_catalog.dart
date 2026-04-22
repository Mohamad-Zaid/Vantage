import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/generated/assets.dart';

// Order matches the “Shop by Categories” design row.
class ShopCategoryCatalogItem {
  const ShopCategoryCatalogItem({
    required this.id,
    required this.titleKey,
    required this.assetPath,
  });

  final String id;
  final String titleKey;
  final String assetPath;
}

const List<ShopCategoryCatalogItem> kShopCategoryCatalog = [
  ShopCategoryCatalogItem(
    id: 'cat_hoodies',
    titleKey: LocaleKeys.home_categoryHoodies,
    assetPath: Assets.categoryHoodies,
  ),
  ShopCategoryCatalogItem(
    id: 'cat_accessories',
    titleKey: LocaleKeys.home_categoryAccessories,
    assetPath: Assets.categoryAccessories,
  ),
  ShopCategoryCatalogItem(
    id: 'cat_shorts',
    titleKey: LocaleKeys.home_categoryShorts,
    assetPath: Assets.categoryShorts,
  ),
  ShopCategoryCatalogItem(
    id: 'cat_shoes',
    titleKey: LocaleKeys.home_categoryShoes,
    assetPath: Assets.categoryShoes,
  ),
  ShopCategoryCatalogItem(
    id: 'cat_bags',
    titleKey: LocaleKeys.home_categoryBag,
    assetPath: Assets.categoryBag,
  ),
];

String? categoryTitleKeyForId(String categoryId) {
  for (final item in kShopCategoryCatalog) {
    if (item.id == categoryId) return item.titleKey;
  }
  return null;
}
