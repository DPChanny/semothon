import 'package:flutter_app/dto/chatting/unread_message_count_dto.dart';

class GetUnreadMessageCountResponseDto {
  final List<UnreadMessageCountDTO> unreadCounts;

  GetUnreadMessageCountResponseDto({required this.unreadCounts});

  factory GetUnreadMessageCountResponseDto.fromJson(Map<String, dynamic> json) {
    return GetUnreadMessageCountResponseDto(
      unreadCounts:
          List<Map<String, dynamic>>.from(
            json['unreadCounts'],
          ).map((e) => UnreadMessageCountDTO.fromJson(e)).toList(),
    );
  }
}
