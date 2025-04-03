import 'package:flutter/material.dart';
import 'package:flutter_app/pages/interest_selection_pages/interest_category_selection_page.dart';
import 'package:flutter_app/pages/interest_selection_pages/interest_selection_page.dart';
import 'package:flutter_app/pages/interest_selection_pages/intro_detail_complete_page.dart';
import 'package:flutter_app/pages/interest_selection_pages/intro_detail_page.dart';
import 'package:flutter_app/pages/main_page/tabs/mentoring_tab/create_room_complete_page.dart';
import 'package:flutter_app/pages/main_page/tabs/mentoring_tab/create_room_page.dart';
import 'package:flutter_app/pages/main_page/tabs/mentoring_tab/short_intro_input_complete_page.dart';
import 'package:flutter_app/pages/main_page/tabs/mentoring_tab/short_intro_input_page.dart';

class MentoringTabRouteNames {
  static const createRoomCompletePage = '/create_room_complete_page';
  static const createRoomPage = '/create_room_page';
  static const shortIntroInputPage = "/short_intro_input_page";
  static const shortIntroInputCompletePage = "/short_intro_input_complete_page";
}

final Map<String, WidgetBuilder> mentoringTabRoutes = {
  MentoringTabRouteNames.createRoomCompletePage:
      (context) => const CreateRoomCompletePage(),
  MentoringTabRouteNames.createRoomPage:
      (context) => const CreateRoomPage(),
  MentoringTabRouteNames.shortIntroInputPage: (context) => const ShortIntroInputPage(),
  MentoringTabRouteNames.shortIntroInputCompletePage:
      (context) => const ShortIntroInputCompletePage(),
};
