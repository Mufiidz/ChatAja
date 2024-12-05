import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../di/injection.dart';
import '../../utils/export_utils.dart';
import '../home/home_screen.dart';
import '../login/login_screen.dart';
import 'cubit/splash_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final SplashCubit _cubit;

  @override
  void initState() {
    _cubit = getIt<SplashCubit>();
    _cubit.initial();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SplashCubit, SplashState>(
        bloc: _cubit,
        listener: (BuildContext context, SplashState state) {
          logger.d('SplashState: $state');
          AppRoute.clearAll(
              state.isSuccess ? const HomeScreen() : const LoginScreen());
        },
        child: const Center(
          child: Text(Constants.appName),
        ),
      ),
    );
  }
}
