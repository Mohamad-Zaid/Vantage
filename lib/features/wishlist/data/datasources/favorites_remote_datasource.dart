import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:vantage/core/constants/app_constants.dart';
import 'package:vantage/core/constants/firestore_fields.dart';
import 'package:vantage/core/persistence/firestore_user_scoped_contexts.dart';
import 'package:vantage/core/domain/entities/product_entity.dart';
import 'package:vantage/features/wishlist/domain/entities/favorites_page_result.dart';

abstract interface class FavoritesRemoteDataSource {
  Stream<List<ProductEntity>> watchFavorites(String userId);

  // Newest first; [startAfterProductId] is the previous page's last id.
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

  CollectionReference<Map<String, dynamic>> _col(String userId) => _db
      .collection(FirestoreUserRoot.collectionId)
      .doc(userId)
      .collection(FavoritesFirestoreContext.collectionId);

  @override
  Stream<List<ProductEntity>> watchFavorites(String userId) {
    return _col(userId).snapshots().map((snap) {
      final docs = snap.docs.toList()
        ..sort((a, b) {
          final ta = a.data()[FavoriteFields.addedAt];
          final tb = b.data()[FavoriteFields.addedAt];
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
    Query<Map<String, dynamic>> query = _col(userId)
        .orderBy(FavoriteFields.addedAt, descending: true)
        .limit(PaginationConstants.defaultPageSize);
    if (startAfterProductId != null) {
      final start = await _col(userId).doc(startAfterProductId).get();
      if (start.exists) {
        query = query.startAfterDocument(start);
      }
    }
    final snap = await query.get();
    final items = snap.docs.map(_docToProduct).toList();
    final hasMore = items.length == PaginationConstants.defaultPageSize;
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
      FavoriteFields.categoryId: p.categoryId,
      FavoriteFields.name: p.name,
      FavoriteFields.description: p.description,
      FavoriteFields.imageUrl: p.imageUrl,
      FavoriteFields.price: p.price,
      FavoriteFields.compareAtPrice: p.compareAtPrice,
      FavoriteFields.rating: p.rating,
      FavoriteFields.stock: p.stock,
      FavoriteFields.addedAt: FieldValue.serverTimestamp(),
    };
  }

  static ProductEntity _docToProduct(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final m = doc.data();
    return ProductEntity(
      id: doc.id,
      categoryId: m[FavoriteFields.categoryId] as String? ?? '',
      name: m[FavoriteFields.name] as String? ?? '',
      description: m[FavoriteFields.description] as String? ?? '',
      imageUrl: m[FavoriteFields.imageUrl] as String? ?? '',
      price: (m[FavoriteFields.price] as num?)?.toDouble() ?? 0,
      compareAtPrice: (m[FavoriteFields.compareAtPrice] as num?)?.toDouble(),
      rating: (m[FavoriteFields.rating] as num?)?.toDouble() ?? 0,
      stock: (m[FavoriteFields.stock] as num?)?.toInt() ?? 0,
    );
  }
}
