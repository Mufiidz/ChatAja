import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:flutter/material.dart';

import 'di/injection.dart';
import 'screen/splash/splash_screen.dart';
import 'utils/export_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait(
      <Future<void>>[EasyLocalization.ensureInitialized(), setupDI()]);
  runApp(EasyLocalization(
    supportedLocales: const <Locale>[
      Locale('id'),
      Locale('en'),
    ],
    path: 'assets/translations',
    fallbackLocale: const Locale('en'),
    startLocale: const Locale('id'),
    assetLoader: const JsonAssetLoader(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: Constants.appName,
        navigatorKey: AppRoute.navigatorKey,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
          useMaterial3: true,
        ),
        home: const SplashScreen()
        // home: const ChatScreen(
        //   user: User(id: 8, username: 'Rayy', email: 'c@mail.com'),
        // ),
        );
  }
}
