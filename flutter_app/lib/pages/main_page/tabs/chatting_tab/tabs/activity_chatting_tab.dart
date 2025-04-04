import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/chat_list_card.dart';
import 'package:flutter_app/widgets/empty_chat_card.dart';

class ActivityChattingTab extends StatelessWidget {
  const ActivityChattingTab({super.key});

  final bool hasChats = true; // 활동 방은 채팅 있다고 가정

  @override
  Widget build(BuildContext context) {
    return hasChats
        ? const ChatListCard()
        : const EmptyChatCard(
          emoji: '👊',
          title: '다른 사람과 함께\n공모전을 도전해보세요',
          subtitle: '으싸으싸 화이팅!',
          buttonText: '공모전 알아보기',
        );
  }
}
