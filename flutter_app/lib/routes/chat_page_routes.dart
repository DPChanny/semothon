import 'package:flutter/material.dart';
import 'package:flutter_app/pages/chat_pages/chat_mentoring_page.dart';
import 'package:flutter_app/pages/chat_pages/search_screen_page.dart';
import 'package:flutter_app/pages/chat_pages/chat_detail_page.dart';

class ChatPageRouteNames {
  static const ChatMentoringPage = '/chat_mentoring_page';
  static const SearchScreenPage = '/search_screen_page';
  static const ChatDetailPage = '/chat_detail_page';
}

final Map<String, WidgetBuilder> chatPageRoutes = {
  ChatPageRouteNames.ChatMentoringPage: (context) => const ChatMentoringPage(),
  ChatPageRouteNames.SearchScreenPage: (context) => const SearchScreenPage(),
  ChatPageRouteNames.ChatDetailPage: (context) => const ChatDetailPage(),
};
