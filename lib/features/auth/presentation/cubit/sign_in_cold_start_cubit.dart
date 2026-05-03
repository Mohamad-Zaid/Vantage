import 'package:flutter_bloc/flutter_bloc.dart';

enum SignInColdStartPhase { checking, ready }

final class SignInColdStartCubit extends Cubit<SignInColdStartPhase> {
  SignInColdStartCubit() : super(SignInColdStartPhase.checking);

  void markReady() {
    if (!isClosed) emit(SignInColdStartPhase.ready);
  }
}
