import 'package:flutter_bloc/flutter_bloc.dart';

import 'navigation_state.dart';

final class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationInitial());

  void selectTab(int index) {
    if (state.currentIndex == index) return;
    emit(NavigationTabSelected(index));
  }
}
