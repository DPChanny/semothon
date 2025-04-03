enum RoomUserRole { MEMBER, ADMIN } // 필요 시 확장 가능

class UserRoomInfoDto {
  final int roomId;
  final RoomUserRole role;
  final DateTime joinedAt;
  final String title;
  final String hostUserId;

  UserRoomInfoDto({
    required this.roomId,
    required this.role,
    required this.joinedAt,
    required this.title,
    required this.hostUserId,
  });

  factory UserRoomInfoDto.fromJson(Map<String, dynamic> json) {
    return UserRoomInfoDto(
      roomId: json['roomId'],
      role: RoomUserRole.values.byName(json['role']),
      joinedAt: DateTime.parse(json['joinedAt']),
      title: json['title'],
      hostUserId: json['hostUserId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'roomId': roomId,
    'role': role.name,
    'joinedAt': joinedAt.toIso8601String(),
    'title': title,
    'hostUserId': hostUserId,
  };
}
