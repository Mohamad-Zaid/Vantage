import 'package:flutter_bloc/flutter_bloc.dart';

final class OrderDetailItemsExpansionCubit extends Cubit<bool> {
  OrderDetailItemsExpansionCubit() : super(false);

  void setExpanded(bool expanded) {
    if (!isClosed) emit(expanded);
  }
}
