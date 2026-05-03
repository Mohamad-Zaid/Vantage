import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:vantage/core/errors/domain_exceptions.dart';
import 'package:vantage/features/cart/data/datasources/cart_remote_datasource.dart';
import 'package:vantage/features/cart/domain/entities/cart_line_entity.dart';
import 'package:vantage/features/cart/domain/entities/cart_line_input.dart';
import 'package:vantage/features/cart/domain/repositories/cart_repository.dart';

final class CartRepositoryImpl implements CartRepository {
  CartRepositoryImpl(this._remote);

  final CartRemoteDataSource _remote;

  @override
  Stream<List<CartLineEntity>> watchCart(String userId) {
    return _remote.watchItems(userId).handleError((Object e, StackTrace st) {
      debugPrint('CartRepositoryImpl.watchCart failed: $e\n$st');
      if (e is FirebaseException) {
        throw RepositoryException(e.message ?? 'Firebase error', cause: e);
      }
      throw e;
    });
  }

  @override
  Future<void> addOrUpdateLine(String userId, CartLineInput input) async {
    try {
      await _remote.addOrUpdateLine(
        userId,
        productId: input.productId,
        name: input.name,
        imageUrl: input.imageUrl,
        unitPrice: input.unitPrice,
        size: input.size,
        colorLabel: input.colorLabel,
        quantityDelta: input.quantityDelta,
      );
    } on FirebaseException catch (e, st) {
      debugPrint('CartRepositoryImpl.addOrUpdateLine failed: $e\n$st');
      throw RepositoryException(e.message ?? 'Firebase error', cause: e);
    }
  }

  @override
  Future<void> setQuantity(String userId, String lineId, int quantity) async {
    try {
      await _remote.setLineQuantity(userId, lineId, quantity);
    } on FirebaseException catch (e, st) {
      debugPrint('CartRepositoryImpl.setQuantity failed: $e\n$st');
      throw RepositoryException(e.message ?? 'Firebase error', cause: e);
    }
  }

  @override
  Future<void> removeLine(String userId, String lineId) async {
    try {
      await _remote.deleteLine(userId, lineId);
    } on FirebaseException catch (e, st) {
      debugPrint('CartRepositoryImpl.removeLine failed: $e\n$st');
      throw RepositoryException(e.message ?? 'Firebase error', cause: e);
    }
  }

  @override
  Future<void> clearCart(String userId) async {
    try {
      await _remote.clearAll(userId);
    } on FirebaseException catch (e, st) {
      debugPrint('CartRepositoryImpl.clearCart failed: $e\n$st');
      throw RepositoryException(e.message ?? 'Firebase error', cause: e);
    }
  }
}
