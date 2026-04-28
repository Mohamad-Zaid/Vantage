import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin CubitErrorHandler<S> on Cubit<S> {
  Future<bool> runGuardedMutation(
    String logContext,
    Future<void> Function() action, {
    required void Function(Object error) onError,
    void Function()? afterError,
  }) async {
    try {
      await action();
      return true;
    } catch (error, stackTrace) {
      debugPrint('$logContext: $error\n$stackTrace');
      if (isClosed) return false;
      onError(error);
      afterError?.call();
      return false;
    }
  }

  Future<T?> runGuardedValue<T>(
    String logContext,
    Future<T> Function() action, {
    required void Function(Object error) onError,
    void Function()? afterError,
  }) async {
    try {
      return await action();
    } catch (error, stackTrace) {
      debugPrint('$logContext: $error\n$stackTrace');
      if (isClosed) return null;
      onError(error);
      afterError?.call();
      return null;
    }
  }
}
