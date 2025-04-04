import 'package:flutter/material.dart';
import 'package:flutter_app/pages/main_page/tabs/chatting_tab/chatting_tab.dart';
import 'package:flutter_app/pages/main_page/tabs/chatting_tab/tabs/chatting_page.dart';
import 'package:flutter_app/pages/main_page/tabs/chatting_tab/tabs/search_chatting_tab.dart';

class ChatPageRouteNames {
  static const chatMentoringPage = '/chat_mentoring_page';
  static const searchScreenPage = '/search_screen_page';
  static const chattingPage = '/chatting_page';
}

final Map<String, WidgetBuilder> chatPageRoutes = {
  ChatPageRouteNames.chatMentoringPage: (context) => const ChattingTab(),
  ChatPageRouteNames.searchScreenPage: (context) => const SearchScreenPage(),
  ChatPageRouteNames.chattingPage: (context) => const ChattingPage(),
};
