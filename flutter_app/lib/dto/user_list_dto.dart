import 'package:flutter_app/dto/user_dto.dart';

class UserListDTO {
  final List<UserDTO> userList;
  final int totalCount;

  UserListDTO({
    required this.userList,
    required this.totalCount,
  });

  factory UserListDTO.fromJson(Map<String, dynamic> json) {
    final List<dynamic> userItems = json['data']['userList'];
    final List<UserDTO> users = userItems
        .map((item) => UserDTO.fromJson(item['userInfo']))
        .toList();

    return UserListDTO(
      userList: users,
      totalCount: json['data']['totalCount'],
    );
  }
}
