import 'room_info_dto.dart';
import 'room_user_info_dto.dart';
import 'host_user_info_dto.dart';

class GetRoomResponseDto {
  final RoomInfoDto roomInfo;
  final List<RoomUserInfoDto> members;
  final HostUserInfoDto host;

  GetRoomResponseDto({
    required this.roomInfo,
    required this.members,
    required this.host,
  });

  factory GetRoomResponseDto.fromJson(Map<String, dynamic> json) {
    return GetRoomResponseDto(
      roomInfo: RoomInfoDto.fromJson(json['roomInfo']),
      members: List<Map<String, dynamic>>.from(json['members'])
          .map((e) => RoomUserInfoDto.fromJson(e))
          .toList(),
      host: HostUserInfoDto.fromJson(json['host']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomInfo': roomInfo.toJson(),
      'members': members.map((e) => e.toJson()).toList(),
      'host': host.toJson(),
    };
  }
}
