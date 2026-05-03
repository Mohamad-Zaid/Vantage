import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vantage/core/domain/failures/failure.dart';

import '../../domain/usecases/get_support_faqs_usecase.dart';
import 'support_state.dart';

final class SupportCubit extends Cubit<SupportState> {
  SupportCubit(this._getFaqs) : super(const SupportInitial()) {
    unawaited(loadFAQs());
  }

  final GetSupportFaqsUseCase _getFaqs;

  Future<void> loadFAQs() async {
    emit(const SupportLoading());
    try {
      final faqs = await _getFaqs();
      if (isClosed) return;
      if (faqs.isEmpty) {
        emit(const SupportEmpty());
      } else {
        emit(SupportLoaded(faqs));
      }
    } catch (e) {
      if (isClosed) return;
      emit(SupportError(UnknownFailure(e.toString())));
    }
  }
}
