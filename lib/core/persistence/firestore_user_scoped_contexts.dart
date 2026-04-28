// Anti-corruption note (bounded contexts on Firebase):
// Auth identities share one physical `users/{userId}` document tree. Each class
// below owns only its subcollection id for that integration boundary so cart,
// orders, favorites, and addresses datasources do not copy each other's path
// segments. Cross-context orchestration stays in application/use-case code.

abstract final class FirestoreUserRoot {
  static const String collectionId = 'users';
}

abstract final class CartFirestoreContext {
  static const String collectionId = 'cartItems';
}

abstract final class OrdersFirestoreContext {
  static const String collectionId = 'orders';
}

abstract final class FavoritesFirestoreContext {
  static const String collectionId = 'favorites';
}

abstract final class AddressesFirestoreContext {
  static const String collectionId = 'addresses';
}
