import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/home_audience.dart';

// State is just [HomeAudience] for the home header control.
final class HomeAudienceCubit extends Cubit<HomeAudience> {
  HomeAudienceCubit() : super(HomeAudience.men);

  void select(HomeAudience audience) => emit(audience);
}
