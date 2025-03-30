import 'package:flutter/material.dart';
import '../pages/login_page.dart';
import '../pages/user_input/birth_input_page.dart';

final Map<String, WidgetBuilder> loginRoutes = {
  '/login': (context) => const LoginPage(),
};

//홈 화면 관련 라우팅