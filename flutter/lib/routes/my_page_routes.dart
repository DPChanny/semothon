import 'package:flutter/material.dart';
import 'package:flutter_app/pages/my_pages/my_interest_page.dart';

class MyPageRouteNames {
  static const myInterestPage = '/my_interest_page';
}

final Map<String, WidgetBuilder> myPageRoutes = {
  MyPageRouteNames.myInterestPage: (context) => MyInterestPage(),
};
