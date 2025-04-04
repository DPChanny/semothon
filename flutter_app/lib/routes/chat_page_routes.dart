import 'package:flutter/material.dart';
import 'package:flutter_app/pages/main_page/tabs/chat_pages/chat_mentoring_page.dart';
import 'package:flutter_app/pages/main_page/tabs/chat_pages/search_screen_page.dart';

class ChatPageRouteNames {
  static const ChatMentoringPage = '/chat_mentoring_page';
  static const SearchScreenPage = '/search_screen_page';
}

final Map<String, WidgetBuilder> chatPageRoutes = {
  ChatPageRouteNames.ChatMentoringPage: (context) => const ChatMentoringPage(),
  ChatPageRouteNames.SearchScreenPage: (context) => const SearchScreenPage(),
};
