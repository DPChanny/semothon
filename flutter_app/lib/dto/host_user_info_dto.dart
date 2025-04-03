class HostUserInfoDto {
  final String userId;
  final String nickname;
  final String profileImageUrl;
  final String shortIntro;

  HostUserInfoDto({
    required this.userId,
    required this.nickname,
    required this.profileImageUrl,
    required this.shortIntro,
  });

  factory HostUserInfoDto.fromJson(Map<String, dynamic> json) {
    return HostUserInfoDto(
      userId: json['userId'],
      nickname: json['nickname'],
      profileImageUrl: json['profileImageUrl'],
      shortIntro: json['shortIntro'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'nickname': nickname,
      'profileImageUrl': profileImageUrl,
      'shortIntro': shortIntro,
    };
  }
}
