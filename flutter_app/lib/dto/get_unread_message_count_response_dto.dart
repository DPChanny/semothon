import 'package:flutter_app/dto/unread_message_count_dto.dart';

class GetUnreadMessageCountResponseDto {
  final List<UnreadMessageCountDto> unreadCounts;

  GetUnreadMessageCountResponseDto({required this.unreadCounts});

  factory GetUnreadMessageCountResponseDto.fromJson(Map<String, dynamic> json) {
    return GetUnreadMessageCountResponseDto(
      unreadCounts:
          List<Map<String, dynamic>>.from(
            json['unreadCounts'],
          ).map((e) => UnreadMessageCountDto.fromJson(e)).toList(),
    );
  }
}
