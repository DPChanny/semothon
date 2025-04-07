import 'package:flutter_app/dto/user/host_user_info_dto.dart';
import 'package:flutter_app/dto/room/room_info_dto.dart';

class GetRoomListResponseDto {
  final List<RoomInfoDto> roomInfos;
  final List<HostUserInfoDto> hostInfos;

  GetRoomListResponseDto({
    required this.roomInfos,
    required this.hostInfos,
  });

  factory GetRoomListResponseDto.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawList = json['roomList'];
    final List<RoomInfoDto> roomInfos = [];
    final List<HostUserInfoDto> hostInfos = [];

    for (var item in rawList) {
      roomInfos.add(RoomInfoDto.fromJson(item['room']));
      hostInfos.add(HostUserInfoDto.fromJson(item['host']));
    }

    return GetRoomListResponseDto(
      roomInfos: roomInfos,
      hostInfos: hostInfos,
    );
  }
}
