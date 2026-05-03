import 'package:vantage/core/domain/failures/failure.dart';

extension FailureDisplayX on Failure {
  /// Returns a human-readable string suitable for display in the UI.
  /// Switch on concrete Failure subtypes to show richer error copy as needed.
  String get displayMessage => switch (this) {
        UnknownFailure(:final message) => message,
        NetworkFailure() => 'Network error. Please check your connection.',
        NotFoundFailure() => 'Not found.',
      };
}
