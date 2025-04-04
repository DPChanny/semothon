import 'package:flutter/material.dart';

class ChatListCard extends StatelessWidget {
  const ChatListCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde',
            ),
          ),
          title: const Text(
            '프로토 뿌시기  💬 3',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              fontFamily: 'Noto Sans KR',
            ),
          ),
          subtitle: const Text(
            '우와 그거는 어떻게 하는 거예요?',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '5:13 PM',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '25/3/20',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
