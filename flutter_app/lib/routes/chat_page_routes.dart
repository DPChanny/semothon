import 'package:flutter/material.dart';
import 'package:flutter_app/pages/chat_mentoring_page.dart';

class ChatPageRouteNames {
  static const ChatMentoringPage = '/chat_mentoring_page';
}

final Map<String, WidgetBuilder> chatPageRoutes = {
  ChatPageRouteNames.ChatMentoringPage: (context) => const ChatMentoringPage(),
};
