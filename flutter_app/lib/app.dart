import 'package:flutter/material.dart';
import 'routes/app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: appRoutes,
      title: 'Semothon',
      debugShowCheckedModeBanner: false
    );
  }
}