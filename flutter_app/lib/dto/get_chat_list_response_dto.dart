import 'chat_room_info_dto.dart';

class GetChatListResponseDto {
  final int totalCount;
  final List<ChatRoomInfoDto> chatRoomList;

  GetChatListResponseDto({
    required this.totalCount,
    required this.chatRoomList,
  });

  factory GetChatListResponseDto.fromJson(Map<String, dynamic> json) {
    return GetChatListResponseDto(
      totalCount: json['totalCount'],
      chatRoomList:
          (json['chatRoomList'] as List)
              .map((e) => ChatRoomInfoDto.fromJson(e))
              .toList(),
    );
  }
}
