import 'package:flutter/material.dart';
import 'package:flutter_app/pages/login_pages/login_complete_page.dart';
import 'package:flutter_app/pages/login_pages/login_page.dart';
import 'package:flutter_app/pages/login_pages/splash_screen_page.dart';

class LoginPageRouteNames {
  static const loginPage = '/login_page';
  static const loginCompletePage = '/login_complete_page';
  static const SplashScreenPage = '/splash_screen_page';
}

final Map<String, WidgetBuilder> loginPageRoutes = {
  LoginPageRouteNames.loginPage: (context) => const LoginPage(),
  LoginPageRouteNames.loginCompletePage: (context) => const LoginCompletePage(),
  LoginPageRouteNames.SplashScreenPage: (context) => const SplashScreen(),
};
