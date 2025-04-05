import 'package:flutter_app/dto/host_user_info_dto.dart';
import 'package:flutter_app/dto/room_user_info_dto.dart';

import 'chat_room_info_dto.dart';

class GetChatResponseDto {
  final ChatRoomInfoDto chatRoomInfo;
  final HostUserInfoDto host;
  final List<RoomUserInfoDto> members;

  GetChatResponseDto({
    required this.chatRoomInfo,
    required this.host,
    required this.members,
  });

  factory GetChatResponseDto.fromJson(Map<String, dynamic> json) {
    return GetChatResponseDto(
      chatRoomInfo: ChatRoomInfoDto.fromJson(json['chatRoomInfo']),
      host: HostUserInfoDto.fromJson(json['host']),
      members:
          (json['members'] as List)
              .map((e) => RoomUserInfoDto.fromJson(e))
              .toList(),
    );
  }
}
