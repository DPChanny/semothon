import 'package:flutter/material.dart';
import 'package:flutter_app/pages/login_complete_page.dart';
import 'package:flutter_app/pages/login_page.dart';
import 'package:flutter_app/pages/user_input/birth_input_page.dart';
import 'package:flutter_app/pages/user_input/department_input_page.dart';
import 'package:flutter_app/pages/user_input/gender_input_page.dart';
import 'package:flutter_app/pages/user_input/name_input_page.dart';
import 'package:flutter_app/pages/user_input/nickname_input_page.dart';
import 'package:flutter_app/pages/user_input/register_complete_page.dart';
import 'package:flutter_app/pages/user_input/student_id_input_page.dart';

final Map<String, WidgetBuilder> loginRoutes = {
  '/login_page': (context) => const LoginPage(),
  '/login_complete_page': (context) => const LoginCompletePage(),
  '/user_input/birth_input_page': (context) => const BirthInputPage(),
  '/user_input/department_input_page': (context) => const DepartmentInputPage(),
  '/user_input/gender_input_page': (context) => const GenderInputPage(),
  '/user_input/name_input_page': (context) => const NameInputPage(),
  '/user_input/nickname_input_page': (context) => const NicknameInputPage(),
  '/user_input/register_complete_page':
      (context) => const RegisterCompletePage(),
  '/user_input/student_id_input_page': (context) => const StudentIdInputPage(),
};
