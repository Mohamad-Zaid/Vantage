final class DomainValidationException implements Exception {
  const DomainValidationException(this.message);

  final String message;

  @override
  String toString() => 'DomainValidationException: $message';
}

class AuthException implements Exception {
  final String message;
  final Object? cause;
  const AuthException(this.message, {this.cause});

  @override
  String toString() => 'AuthException: $message${cause != null ? ' (caused by: $cause)' : ''}';
}

class OrderNotFoundException implements Exception {
  final String orderId;
  const OrderNotFoundException(this.orderId);

  @override
  String toString() => 'OrderNotFoundException: no order found with id "$orderId"';
}

class RepositoryException implements Exception {
  final String message;
  final Object? cause;
  const RepositoryException(this.message, {this.cause});

  @override
  String toString() => 'RepositoryException: $message${cause != null ? ' (caused by: $cause)' : ''}';
}
