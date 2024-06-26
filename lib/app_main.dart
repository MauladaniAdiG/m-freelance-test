import 'dart:async';

import 'package:app/config/app_config.dart';
import 'package:app/config/app_localization.dart';
import 'package:app/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runZonedGuarded(
    () async {
      await _initializeApp();
      runApp(const MyApp());
    },
    (error, stack) {},
  );
}

Future<void> _initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.setupEnv();
  AppLocalization.current.load(WidgetsBinding.instance.platformDispatcher.locale);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'm-test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
          },
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalization.current.supportedLocales,
      home: const HomeScreen(),
    );
  }
}
