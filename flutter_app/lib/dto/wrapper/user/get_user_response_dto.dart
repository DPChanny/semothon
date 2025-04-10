import 'package:flutter_app/dto/chatting/chat_room_info_dto.dart';
import 'package:flutter_app/dto/user/user_info_dto.dart';

class GetUserResponseDto {
  final UserInfoDto userInfo;
  final List<ChatRoomInfoDTO> chatRooms;

  GetUserResponseDto({required this.userInfo, required this.chatRooms});

  factory GetUserResponseDto.fromJson(Map<String, dynamic> json) {
    return GetUserResponseDto(
      userInfo: UserInfoDto.fromJson(json['user']),
      chatRooms:
          List<Map<String, dynamic>>.from(json['chatRooms'])
              .map((chatRoomJson) => ChatRoomInfoDTO.fromJson(chatRoomJson))
              .toList(),
    );
  }

  bool isHost() {
    return chatRooms.any((room) => room.hostUserId == userInfo.userId);
  }
}
