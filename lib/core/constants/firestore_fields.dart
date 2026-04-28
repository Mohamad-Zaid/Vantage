abstract final class AddressFields {
  static const String street = 'street';
  static const String city = 'city';
  static const String state = 'state';
  static const String zipCode = 'zipCode';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
}

abstract final class OrderLineItemFields {
  static const String productId = 'productId';
  static const String name = 'name';
  static const String imageUrl = 'imageUrl';
  static const String unitPrice = 'unitPrice';
  static const String quantity = 'quantity';
  static const String size = 'size';
  static const String colorLabel = 'colorLabel';
}

abstract final class CartItemFields {
  static const String updatedAt = 'updatedAt';
}

abstract final class OrderDocFields {
  static const String status = 'status';
  static const String createdAt = 'createdAt';
  static const String items = 'items';
  static const String address = 'address';
  static const String subtotal = 'subtotal';
  static const String shipping = 'shipping';
  static const String tax = 'tax';
  static const String total = 'total';
  static const String addressId = 'addressId';
  static const String paymentLabel = 'paymentLabel';
}

abstract final class FavoriteFields {
  static const String categoryId = 'categoryId';
  static const String name = 'name';
  static const String description = 'description';
  static const String imageUrl = 'imageUrl';
  static const String price = 'price';
  static const String compareAtPrice = 'compareAtPrice';
  static const String rating = 'rating';
  static const String stock = 'stock';
  static const String addedAt = 'addedAt';
}
