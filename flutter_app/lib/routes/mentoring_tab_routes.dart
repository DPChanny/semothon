import 'package:flutter/material.dart';
import 'package:flutter_app/pages/main_page/tabs/mentoring_tab/tabs/my_mentor_tab/pages/create_room_complete_page.dart';
import 'package:flutter_app/pages/main_page/tabs/mentoring_tab/tabs/my_mentor_tab/pages/create_room_page.dart';
import 'package:flutter_app/pages/main_page/tabs/mentoring_tab/tabs/my_mentor_tab/pages/short_intro_input_complete_page.dart';
import 'package:flutter_app/pages/main_page/tabs/mentoring_tab/tabs/my_mentor_tab/pages/short_intro_input_page.dart';
import 'package:flutter_app/pages/main_page/tabs/mentoring_tab/tabs/search_tab.dart';

class MyMentorTabRouteNames {
  static const createRoomCompletePage = '/create_room_complete_page';
  static const createRoomPage = '/create_room_page';
  static const shortIntroInputPage = "/short_intro_input_page";
  static const shortIntroInputCompletePage = "/short_intro_input_complete_page";
  static const searchPage = '/search_page';
}

final Map<String, WidgetBuilder> myMentorTabRoutes = {
  MyMentorTabRouteNames.createRoomCompletePage:
      (context) => const CreateRoomCompletePage(),
  MyMentorTabRouteNames.createRoomPage: (context) => const CreateRoomPage(),
  MyMentorTabRouteNames.shortIntroInputPage:
      (context) => const ShortIntroInputPage(),
  MyMentorTabRouteNames.shortIntroInputCompletePage:
      (context) => const ShortIntroInputCompletePage(),
  MyMentorTabRouteNames.searchPage:
  (context) => const SearchPage(),
};
