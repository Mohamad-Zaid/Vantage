import 'package:flutter/material.dart';

import 'package:vantage/di/injection.dart';

import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../navigation/presentation/cubit/navigation_cubit.dart';
import '../cubit/home_audience_cubit.dart';
import '../cubit/product_cubit.dart';
import '../widgets/home_body.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.navigationCubit});

  final NavigationCubit navigationCubit;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ProductCubit _productCubit;
  late final HomeAudienceCubit _audienceCubit;
  late final AuthCubit _authCubit;

  @override
  void initState() {
    super.initState();
    _productCubit = sl<ProductCubit>();
    _audienceCubit = sl<HomeAudienceCubit>();
    _authCubit = sl<AuthCubit>();
  }

  @override
  void dispose() {
    _productCubit.close();
    _audienceCubit.close();
    _authCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HomeBody(
      navigationCubit: widget.navigationCubit,
      productCubit: _productCubit,
      audienceCubit: _audienceCubit,
      authCubit: _authCubit,
    );
  }
}
