import 'package:flutter_app/dto/chatting/chat_room_info_dto.dart';
import 'package:flutter_app/dto/user/host_user_info_dto.dart';
import 'package:flutter_app/dto/user/room_user_info_dto.dart';

class GetChatResponseDto {
  final ChatRoomInfoDTO chatRoomInfo;
  final HostUserInfoDto host;
  final List<RoomUserInfoDto> members;

  GetChatResponseDto({
    required this.chatRoomInfo,
    required this.host,
    required this.members,
  });

  factory GetChatResponseDto.fromJson(Map<String, dynamic> json) {
    return GetChatResponseDto(
      chatRoomInfo: ChatRoomInfoDTO.fromJson(json['chatRoomInfo']),
      host: HostUserInfoDto.fromJson(json['host']),
      members:
          (json['members'] as List)
              .map((e) => RoomUserInfoDto.fromJson(e))
              .toList(),
    );
  }
}
