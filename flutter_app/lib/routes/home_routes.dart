import 'package:flutter/material.dart';
import '../pages/home_page.dart';

final Map<String, WidgetBuilder> homeRoutes = {
  '/home': (context) => const HomePage(),
};

//홈 화면 관련 라우팅