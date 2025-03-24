import 'package:flutter/material.dart';
import 'pages/home_page.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => const HomePage(),
  };
}
