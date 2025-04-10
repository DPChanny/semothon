import '../../chatting/chat_room_info_dto.dart';

class GetChatListResponseDto {
  final List<ChatRoomInfoDTO> chatRoomList;

  GetChatListResponseDto({
    required this.chatRoomList,
  });

  factory GetChatListResponseDto.fromJson(Map<String, dynamic> json) {
    return GetChatListResponseDto(
      chatRoomList:
          (json['chatRoomList'] as List)
              .map((e) => ChatRoomInfoDTO.fromJson(e))
              .toList(),
    );
  }
}
