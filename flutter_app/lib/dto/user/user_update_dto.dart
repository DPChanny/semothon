class UserUpdateDTO {
  static UserUpdateDTO instance = UserUpdateDTO();

  String? name;
  String? nickname;
  String? department;
  String? studentId;
  DateTime? birthdate;
  String? gender;
  String? introText;
  String? shortIntro;
  String? profileImageUrl;

  UserUpdateDTO({
    this.name,
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
    final data = <String, dynamic>{};

    if (name != null) data['name'] = name;
    if (nickname != null) data['nickname'] = nickname;
    if (department != null) data['department'] = department;
    if (studentId != null) data['studentId'] = studentId;
    if (birthdate != null) data['birthdate'] = birthdate!.toIso8601String();
    if (gender != null) data['gender'] = gender;
    if (introText != null) data['introText'] = introText;
    if (shortIntro != null) data['shortIntro'] = shortIntro;
    if (profileImageUrl != null) data['profileImageUrl'] = profileImageUrl;

    return data;
  }
}
