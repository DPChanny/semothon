class UserInfo {
  String name;
  String nickname;
  String department;
  String studentId;
  String birth;
  String gender;

  UserInfo({
    required this.name,
    required this.nickname,
    required this.department,
    required this.studentId,
    required this.birth,
    required this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nickname': nickname,
      'department': department,
      'studentId': studentId,
      'birth': birth,
      'gender': gender,
    };
  }

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      name: json['name'] ?? '',
      nickname: json['nickname'] ?? '',
      department: json['department'] ?? '',
      studentId: json['studentId'] ?? '',
      birth: json['birth'] ?? '',
      gender: json['gender'] ?? '',
    );
  }

  @override
  String toString() {
    return 'UserInfo(name: $name, nickname: $nickname, department: $department, studentId: $studentId, birth: $birth, gender: $gender)';
  }
}
