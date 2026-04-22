import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:vantage/core/domain/entities/product_entity.dart';
import 'package:vantage/features/wishlist/domain/entities/favorites_page_result.dart';

const int kFavoritesPageSize = 15;

abstract interface class FavoritesRemoteDataSource {
  Stream<List<ProductEntity>> watchFavorites(String userId);

  // Newest first; [startAfterProductId] is the previous page’s last id.
  Future<FavoritesPageResult> getFavoritesPage(
    String userId, {
    String? startAfterProductId,
  });

  Future<void> addFavorite(String userId, ProductEntity product);

  Future<void> removeFavorite(String userId, String productId);
}

final class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  FavoritesRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> _col(String userId) =>
      _db.collection('users').doc(userId).collection('favorites');

  @override
  Stream<List<ProductEntity>> watchFavorites(String userId) {
    return _col(userId).snapshots().map((snap) {
      final docs = snap.docs.toList()
        ..sort((a, b) {
          final ta = a.data()['addedAt'];
          final tb = b.data()['addedAt'];
          if (ta is Timestamp && tb is Timestamp) {
            return tb.compareTo(ta);
          }
          return 0;
        });
      return docs.map(_docToProduct).toList();
    });
  }

  @override
  Future<FavoritesPageResult> getFavoritesPage(
    String userId, {
    String? startAfterProductId,
  }) async {
    Query<Map<String, dynamic>> q = _col(userId)
        .orderBy('addedAt', descending: true)
        .limit(kFavoritesPageSize);
    if (startAfterProductId != null) {
      final start = await _col(userId).doc(startAfterProductId).get();
      if (start.exists) {
        q = q.startAfterDocument(start);
      }
    }
    final snap = await q.get();
    final items = snap.docs.map(_docToProduct).toList();
    final hasMore = items.length == kFavoritesPageSize;
    final next = hasMore && items.isNotEmpty ? items.last.id : null;
    return FavoritesPageResult(
      items: items,
      hasMore: hasMore,
      nextCursorProductId: next,
    );
  }

  @override
  Future<void> addFavorite(String userId, ProductEntity product) {
    return _col(userId).doc(product.id).set(_productToMap(product));
  }

  @override
  Future<void> removeFavorite(String userId, String productId) {
    return _col(userId).doc(productId).delete();
  }

  static Map<String, dynamic> _productToMap(ProductEntity p) {
    return {
      'categoryId': p.categoryId,
      'name': p.name,
      'description': p.description,
      'imageUrl': p.imageUrl,
      'price': p.price,
      'compareAtPrice': p.compareAtPrice,
      'rating': p.rating,
      'stock': p.stock,
      'addedAt': FieldValue.serverTimestamp(),
    };
  }

  static ProductEntity _docToProduct(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final m = doc.data();
    return ProductEntity(
      id: doc.id,
      categoryId: m['categoryId'] as String? ?? '',
      name: m['name'] as String? ?? '',
      description: m['description'] as String? ?? '',
      imageUrl: m['imageUrl'] as String? ?? '',
      price: (m['price'] as num?)?.toDouble() ?? 0,
      compareAtPrice: (m['compareAtPrice'] as num?)?.toDouble(),
      rating: (m['rating'] as num?)?.toDouble() ?? 0,
      stock: (m['stock'] as num?)?.toInt() ?? 0,
    );
  }
}
