import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:vantage/core/domain/entities/product_entity.dart';
import 'package:vantage/core/errors/domain_exceptions.dart';
import 'package:vantage/features/wishlist/domain/entities/favorites_page_result.dart';

import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_remote_datasource.dart';

final class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl(this._remote);

  final FavoritesRemoteDataSource _remote;

  @override
  Stream<List<ProductEntity>> watchFavoritesForUser(String userId) {
    return _remote.watchFavorites(userId).handleError((Object error, StackTrace stackTrace) {
      debugPrint('FavoritesRepositoryImpl.watchFavoritesForUser failed: $error\n$stackTrace');
      if (error is FirebaseException) {
        throw RepositoryException(error.message ?? 'Firebase error', cause: error);
      }
      throw error;
    });
  }

  @override
  Future<FavoritesPageResult> getFavoritesPage(
    String userId, {
    String? cursor,
  }) async {
    try {
      return await _remote.getFavoritesPage(
        userId,
        startAfterProductId: cursor,
      );
    } on FirebaseException catch (error, stackTrace) {
      debugPrint('FavoritesRepositoryImpl.getFavoritesPage failed: $error\n$stackTrace');
      throw RepositoryException(error.message ?? 'Firebase error', cause: error);
    }
  }

  @override
  Future<void> addFavorite(String userId, ProductEntity product) async {
    try {
      await _remote.addFavorite(userId, product);
    } on FirebaseException catch (error, stackTrace) {
      debugPrint('FavoritesRepositoryImpl.addFavorite failed: $error\n$stackTrace');
      throw RepositoryException(error.message ?? 'Firebase error', cause: error);
    }
  }

  @override
  Future<void> removeFavorite(String userId, String productId) async {
    try {
      await _remote.removeFavorite(userId, productId);
    } on FirebaseException catch (error, stackTrace) {
      debugPrint('FavoritesRepositoryImpl.removeFavorite failed: $error\n$stackTrace');
      throw RepositoryException(error.message ?? 'Firebase error', cause: error);
    }
  }
}
