import 'package:equatable/equatable.dart';

class OrderTimelineStepEntity extends Equatable {
  const OrderTimelineStepEntity({
    required this.titleKey,
    required this.dateText,
    required this.isComplete,
  });

  final String titleKey;
  final String dateText;
  final bool isComplete;

  @override
  List<Object?> get props => [titleKey, dateText, isComplete];
}
