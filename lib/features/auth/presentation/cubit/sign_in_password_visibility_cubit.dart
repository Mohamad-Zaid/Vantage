import 'package:flutter_bloc/flutter_bloc.dart';

final class SignInPasswordVisibilityCubit extends Cubit<bool> {
  SignInPasswordVisibilityCubit() : super(true);

  void toggle() => emit(!state);
}
