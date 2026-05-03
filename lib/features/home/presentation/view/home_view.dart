import 'package:flutter/material.dart';

import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../navigation/presentation/cubit/navigation_cubit.dart';
import '../cubit/home_audience_cubit.dart';
import '../cubit/product_cubit.dart';
import '../widgets/home_body.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.navigationCubit,
    required this.productCubit,
    required this.audienceCubit,
    required this.authCubit,
  });

  final NavigationCubit navigationCubit;
  final ProductCubit productCubit;
  final HomeAudienceCubit audienceCubit;
  final AuthCubit authCubit;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void dispose() {
    widget.productCubit.close();
    widget.audienceCubit.close();
    widget.authCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HomeBody(
      navigationCubit: widget.navigationCubit,
      productCubit: widget.productCubit,
      audienceCubit: widget.audienceCubit,
      authCubit: widget.authCubit,
    );
  }
}
