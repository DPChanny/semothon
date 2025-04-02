import 'package:flutter/cupertino.dart';
import 'package:flutter_app/pages/input_pages/birth_input_page.dart';
import 'package:flutter_app/pages/input_pages/department_input_page.dart';
import 'package:flutter_app/pages/input_pages/gender_input_page.dart';
import 'package:flutter_app/pages/input_pages/input_complete_page.dart';
import 'package:flutter_app/pages/input_pages/name_input_page.dart';
import 'package:flutter_app/pages/input_pages/nickname_input_page.dart';
import 'package:flutter_app/pages/input_pages/student_id_input_page.dart';

class InputPageRouteNames {
  static const birthInputPage = '/birth_input_page';
  static const departmentInputPage = '/department_input_page';
  static const genderInputPage = '/gender_input_page';
  static const nameInputPage = '/name_input_page';
  static const nicknameInputPage = '/nickname_input_page';
  static const inputCompletePage = '/input_complete_page';
  static const studentIdInputPage = '/student_id_input_page';
}

final Map<String, WidgetBuilder> inputPageRoutes = {
  InputPageRouteNames.birthInputPage: (context) => const BirthInputPage(),
  InputPageRouteNames.departmentInputPage:
      (context) => const DepartmentInputPage(),
  InputPageRouteNames.genderInputPage: (context) => const GenderInputPage(),
  InputPageRouteNames.nameInputPage: (context) => const NameInputPage(),
  InputPageRouteNames.nicknameInputPage: (context) => const NicknameInputPage(),
  InputPageRouteNames.inputCompletePage: (context) => const InputCompletePage(),
  InputPageRouteNames.studentIdInputPage:
      (context) => const StudentIdInputPage(),
};
