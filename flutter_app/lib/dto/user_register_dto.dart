class UserRegisterDTO {
  static final UserRegisterDTO instance = UserRegisterDTO();

  String? nickname;
  String? department;
  String? studentId;
  DateTime? birthdate;
  String? gender;
  String? introText;
  String? shortIntro;
  String? profileImageUrl;

  UserRegisterDTO({
    this.nickname,
    this.department,
    this.studentId,
    this.birthdate,
    this.gender,
    this.introText,
    this.shortIntro,
    this.profileImageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'department': department,
      'studentId': studentId,
      'birthdate': birthdate?.toIso8601String(),
      'gender': gender,
      'introText': introText,
      'shortIntro': shortIntro,
      'profileImageUrl': profileImageUrl,
    };
  }
}
