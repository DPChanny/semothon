import 'package:flutter/material.dart';
import 'package:flutter_app/routes/chat_page_routes.dart';
import 'package:flutter_app/routes/input_page_routes.dart';
import 'package:flutter_app/routes/interest_page_routes.dart';
import 'package:flutter_app/routes/login_page_routes.dart';
import 'package:flutter_app/routes/main_page_routes.dart';
import 'package:flutter_app/routes/mentoring_tab_routes.dart';

import 'my_page_routes.dart';

final Map<String, WidgetBuilder> appRoutes = {
  ...mainPageRoutes,
  ...loginPageRoutes,
  ...inputPageRoutes,
  ...interestPageRoutes,
  ...chatPageRoutes,
  ...myMentorTabRoutes,
  ...myPageRoutes
};
