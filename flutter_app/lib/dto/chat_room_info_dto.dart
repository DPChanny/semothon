import 'package:flutter_app/dto/message_info_dto.dart';

class ChatRoomInfoDto {
  final int chatRoomId;
  final String type;
  final String title;
  final String description;
  final int capacity;
  final int? roomId;
  final int? crawlingId;
  final int currentMemberCount;
  final DateTime createdAt;
  final String profileImageUrl;
  final String hostUserId;
  final MessageInfoDto? lastMessage;

  ChatRoomInfoDto({
    required this.chatRoomId,
    required this.type,
    required this.title,
    required this.description,
    required this.capacity,
    this.roomId,
    this.crawlingId,
    required this.currentMemberCount,
    required this.createdAt,
    required this.profileImageUrl,
    required this.hostUserId,
    required this.lastMessage,
  });

  factory ChatRoomInfoDto.fromJson(Map<String, dynamic> json) {
    return ChatRoomInfoDto(
      chatRoomId: json['chatRoomId'],
      type: json['type'],
      title: json['title'],
      description: json['description'],
      capacity: json['capacity'],
      roomId: json['roomId'],
      crawlingId: json['crawlingId'],
      currentMemberCount: json['currentMemberCount'],
      createdAt: DateTime.parse(json['createdAt']),
      profileImageUrl: json['profileImageUrl'],
      hostUserId: json['hostUserId'],
      lastMessage:
          json['lastMessage'] != null
              ? MessageInfoDto.fromJson(json['lastMessage'])
              : null,
    );
  }
}
