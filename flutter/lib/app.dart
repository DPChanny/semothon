import 'package:flutter/material.dart';
import 'package:flutter_app/routes/app_routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale('ko', ''), Locale('en', '')],
      initialRoute: '/splash_screen_page',
      routes: appRoutes,
      title: 'Semothon',
      debugShowCheckedModeBanner: false,
    );
  }
}
