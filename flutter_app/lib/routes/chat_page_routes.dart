import 'package:flutter/material.dart';
import 'package:flutter_app/pages/main_page/tabs/chatting_tab/tabs/chatting_page.dart';
import 'package:flutter_app/pages/main_page/tabs/chatting_tab/tabs/search_chatting_page.dart';

class ChatPageRouteNames {
  static const searchChattingPage = '/search_chatting_page';
  static const chattingPage = '/chatting_page';
}

final Map<String, WidgetBuilder> chatPageRoutes = {
  ChatPageRouteNames.searchChattingPage: (context) => const SearchChattingPage(),
  ChatPageRouteNames.chattingPage: (context) => const ChattingPage(),
};
