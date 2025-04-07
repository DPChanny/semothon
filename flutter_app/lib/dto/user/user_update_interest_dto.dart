class UserUpdateInterestIntroDTO {
  static final UserUpdateInterestIntroDTO instance =
      UserUpdateInterestIntroDTO();

  String? interestCategory;
  List<String> interestNames = [];
  String? generatedIntroText;
  String? intro;

  UserUpdateInterestIntroDTO({this.interestCategory, this.generatedIntroText});

  Map<String, dynamic> toInterestJson() {
    return {'interestNames': interestNames};
  }

  Map<String, dynamic> toIntroJson() {
    return {'intro': intro};
  }
}
