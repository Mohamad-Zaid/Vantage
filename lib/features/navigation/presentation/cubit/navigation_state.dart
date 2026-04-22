import 'package:equatable/equatable.dart';

sealed class NavigationState extends Equatable {
  const NavigationState(this.currentIndex);

  final int currentIndex;

  @override
  List<Object?> get props => [currentIndex];
}

final class NavigationInitial extends NavigationState {
  const NavigationInitial() : super(0);
}

final class NavigationTabSelected extends NavigationState {
  const NavigationTabSelected(super.currentIndex);
}
