import 'package:flutter_app/dto/user_info_dto.dart';
import 'package:flutter_app/dto/user_room_info_dto.dart';

class GetUserResponseDto {
  final UserInfoDto userInfo;
  final List<UserRoomInfoDto> rooms;

  GetUserResponseDto({required this.userInfo, required this.rooms});

  factory GetUserResponseDto.fromJson(Map<String, dynamic> json) {
    return GetUserResponseDto(
      userInfo: UserInfoDto.fromJson(json['user']),
      rooms:
          List<Map<String, dynamic>>.from(
            json['rooms'],
          ).map((roomJson) => UserRoomInfoDto.fromJson(roomJson)).toList(),
    );
  }

  bool isHost() {
    return rooms.any((room) => room.role == RoomUserRole.ADMIN);
  }
}
