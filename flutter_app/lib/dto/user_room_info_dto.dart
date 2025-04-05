class UserRoomInfoDto {
  final int roomId;
  final DateTime joinedAt;
  final String title;
  final String hostUserId;

  UserRoomInfoDto({
    required this.roomId,
    required this.joinedAt,
    required this.title,
    required this.hostUserId,
  });

  factory UserRoomInfoDto.fromJson(Map<String, dynamic> json) {
    return UserRoomInfoDto(
      roomId: json['roomId'],
      joinedAt: DateTime.parse(json['joinedAt']),
      title: json['title'],
      hostUserId: json['hostUserId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'roomId': roomId,
    'joinedAt': joinedAt.toIso8601String(),
    'title': title,
    'hostUserId': hostUserId,
  };
}
