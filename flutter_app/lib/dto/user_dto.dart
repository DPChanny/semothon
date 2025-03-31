class UserDTO {
  final String userId;
  final String? nickname;
  final String? department;
  final String? studentId;
  final DateTime? birthdate;
  final String? gender;
  final String? profileImageUrl;
  final String socialProvider;
  final String socialId;
  final String? introText;
  final String? shortIntro;
  final DateTime createdAt;

  UserDTO({
    required this.userId,
    this.nickname,
    this.department,
    this.studentId,
    this.birthdate,
    this.gender,
    this.profileImageUrl,
    required this.socialProvider,
    required this.socialId,
    this.introText,
    this.shortIntro,
    required this.createdAt,
  });

  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
      userId: json['userId'],
      nickname: json['nickname'],
      department: json['department'],
      studentId: json['studentId'],
      birthdate:
          json['birthdate'] != null ? DateTime.parse(json['birthdate']) : null,
      gender: json['gender'],
      profileImageUrl:
          json['profileImageUrl'] ??
          'https://semothon.s3.ap-northeast-2.amazonaws.com/profile-images/default.png',
      socialProvider: json['socialProvider'],
      socialId: json['socialId'],
      introText: json['introText'],
      shortIntro: json['shortIntro'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'nickname': nickname,
      'department': department,
      'studentId': studentId,
      'birthdate': birthdate?.toIso8601String(),
      'gender': gender,
      'profileImageUrl': profileImageUrl,
      'socialProvider': socialProvider,
      'socialId': socialId,
      'introText': introText,
      'shortIntro': shortIntro,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
