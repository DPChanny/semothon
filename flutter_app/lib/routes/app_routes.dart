import 'package:flutter/material.dart';
import 'home_routes.dart';
import 'login_routes.dart';

final Map<String, WidgetBuilder> appRoutes = {
  ...homeRoutes,...loginRoutes,
};
