import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:vantage/generated/assets.dart';

import '../models/category_model.dart';
import '../models/product_model.dart';

abstract interface class ShopLocalDataSource {
  Future<List<CategoryModel>> getCategories();

  Future<List<ProductModel>> getProducts();

  Future<
      ({
        List<ProductModel> topSelling,
        List<({String titleKey, List<ProductModel> products})> newInByCategory,
      })> getHomeShelfModels();
}

final class ShopLocalDataSourceImpl implements ShopLocalDataSource {
  ShopLocalDataSourceImpl();

  static const String _assetPath = Assets.dataProducts;

  Future<Map<String, dynamic>> _loadJson() async {
    final str = await rootBundle.loadString(_assetPath);
    return json.decode(str) as Map<String, dynamic>;
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final data = await _loadJson();
    final list = data['categories'] as List<dynamic>? ?? [];
    return list
        .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ProductModel>> getProducts() async {
    final data = await _loadJson();
    final list = data['products'] as List<dynamic>? ?? [];
    return list
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<
      ({
        List<ProductModel> topSelling,
        List<({String titleKey, List<ProductModel> products})> newInByCategory,
      })> getHomeShelfModels() async {
    final data = await _loadJson();
    final list = data['products'] as List<dynamic>? ?? [];
    final productModels = list
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
    final byId = {for (final p in productModels) p.id: p};

    List<String> idList(String key) {
      final raw = data['home_lists'] as Map<String, dynamic>?;
      final arr = raw?[key] as List<dynamic>? ?? const [];
      return arr.map((e) => e as String).toList();
    }

    List<ProductModel> pick(List<String> ids) =>
        ids.map((id) => byId[id]).whereType<ProductModel>().toList();

    var topSelling = pick(idList('top_selling'));

    final homeLists = data['home_lists'] as Map<String, dynamic>?;
    final shelvesRaw = homeLists?['new_in_shelves'] as List<dynamic>?;

    var newInByCategory =
        <({String titleKey, List<ProductModel> products})>[];
    if (shelvesRaw != null) {
      for (final e in shelvesRaw) {
        final m = e as Map<String, dynamic>;
        final titleKey = m['title_key'] as String;
        final ids = (m['product_ids'] as List<dynamic>? ?? const [])
            .map((x) => x as String)
            .toList();
        newInByCategory.add((
          titleKey: titleKey,
          products: pick(ids),
        ));
      }
    }

    // Old JSON: flat `new_in` list when `new_in_shelves` is absent.
    if (newInByCategory.isEmpty) {
      var legacyNewIn = pick(idList('new_in'));
      if (legacyNewIn.isEmpty && productModels.length >= 6) {
        legacyNewIn = productModels.skip(3).take(3).toList();
      } else if (legacyNewIn.isEmpty && productModels.length > 3) {
        legacyNewIn = productModels.skip(3).toList();
      }
      if (legacyNewIn.isNotEmpty) {
        newInByCategory = [
          (titleKey: 'home.newIn', products: legacyNewIn),
        ];
      }
    }

    if (topSelling.isEmpty && productModels.length >= 3) {
      topSelling = productModels.take(3).toList();
    }

    return (topSelling: topSelling, newInByCategory: newInByCategory);
  }
}
