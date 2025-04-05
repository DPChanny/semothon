import 'package:flutter_app/dto/chat_room_info_dto.dart';

import 'host_user_info_dto.dart';
import 'room_info_dto.dart';
import 'room_user_info_dto.dart';

class GetRoomResponseDto {
  final RoomInfoDto room;
  final List<RoomUserInfoDto> members;
  final HostUserInfoDto host;
  final ChatRoomInfoDto chatRoom;

  GetRoomResponseDto({
    required this.room,
    required this.members,
    required this.host,
    required this.chatRoom,
  });

  factory GetRoomResponseDto.fromJson(Map<String, dynamic> json) {
    return GetRoomResponseDto(
      room: RoomInfoDto.fromJson(json['room']),
      members:
          List<Map<String, dynamic>>.from(
            json['members'],
          ).map((e) => RoomUserInfoDto.fromJson(e)).toList(),
      host: HostUserInfoDto.fromJson(json['host']),
      chatRoom: ChatRoomInfoDto.fromJson(json['chatRoom']['chatRoomInfo']),
    );
  }
}
