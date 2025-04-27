class UserInfoDto {
  final String userId;
  final String? name;
  final String? nickname;
  final String? department;
  final String? studentId;
  final DateTime? birthdate;
  final String? gender;
  final String profileImageUrl;
  final String socialProvider;
  final String socialId;
  final String? introText;
  final String? shortIntro;
  final DateTime createdAt;
  final List<String> interests;

  UserInfoDto({
    required this.userId,
    this.name,
    this.nickname,
    this.department,
    this.studentId,
    this.birthdate,
    this.gender,
    required this.profileImageUrl,
    required this.socialProvider,
    required this.socialId,
    this.introText,
    this.shortIntro,
    required this.createdAt,
    required this.interests,
  });

  factory UserInfoDto.fromJson(Map<String, dynamic> json) {
    return UserInfoDto(
      userId: json['userId'] ?? '',
      name: json['name'],
      nickname: json['nickname'],
      department: json['department'],
      studentId: json['studentId'],
      birthdate:
          json['birthdate'] != null
              ? DateTime.tryParse(json['birthdate'])
              : null,
      gender: json['gender'],
      profileImageUrl: json['profileImageUrl'] ?? '',
      socialProvider: json['socialProvider'] ?? '',
      socialId: json['socialId'] ?? '',
      introText: json['introText'],
      shortIntro: json['shortIntro'],
      createdAt: DateTime.parse(json['createdAt']),
      interests:
          json['interests'] != null ? List<String>.from(json['interests']) : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'name': name,
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
    'interests': interests,
  };
}
