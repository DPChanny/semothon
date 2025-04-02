import 'package:flutter/material.dart';
import 'package:flutter_app/pages/main_page/main_page.dart';

class MainPageRouteNames {
  static const mainPage = '/main_page';
}

final Map<String, WidgetBuilder> mainPageRoutes = {
  MainPageRouteNames.mainPage: (context) => const MainPage(),
};
