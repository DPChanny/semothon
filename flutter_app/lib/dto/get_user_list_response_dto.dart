import 'package:flutter_app/dto/user_info_dto.dart';

class GetUserListResponseDto {
  final List<UserInfoDto> userInfos;

  GetUserListResponseDto({required this.userInfos});

  factory GetUserListResponseDto.fromJson(Map<String, dynamic> json) {
    return GetUserListResponseDto(
      userInfos:
          List<Map<String, dynamic>>.from(
            json['userList'],
          ).map((item) => UserInfoDto.fromJson(item['userInfo'])).toList(),
    );
  }
}
