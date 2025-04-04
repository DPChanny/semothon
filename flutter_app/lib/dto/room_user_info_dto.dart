class RoomUserInfoDto {
  final String userId;
  final String nickname;
  final String profileImageUrl;
  final String shortIntro;
  final String role;
  final DateTime joinedAt;

  RoomUserInfoDto({
    required this.userId,
    required this.nickname,
    required this.profileImageUrl,
    required this.shortIntro,
    required this.role,
    required this.joinedAt,
  });

  factory RoomUserInfoDto.fromJson(Map<String, dynamic> json) {
    return RoomUserInfoDto(
      userId: json['userId'],
      nickname: json['nickname'],
      profileImageUrl: json['profileImageUrl'],
      shortIntro: json['shortIntro'],
      role: json['role'],
      // 서버에서 문자열로 넘어온다고 가정
      joinedAt: DateTime.parse(json['joinedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'nickname': nickname,
      'profileImageUrl': profileImageUrl,
      'shortIntro': shortIntro,
      'role': role,
      'joinedAt': joinedAt.toIso8601String(),
    };
  }
}
