class UpdateUserInterestDTO {
  static final UpdateUserInterestDTO instance =
      UpdateUserInterestDTO();

  String? interestCategory;
  List<String> interestNames = [];
  String? generatedIntroText;
  String? intro;

  UpdateUserInterestDTO({this.interestCategory, this.generatedIntroText});

  Map<String, dynamic> toInterestJson() {
    return {'interestNames': interestNames};
  }

  Map<String, dynamic> toIntroJson() {
    return {'intro': intro};
  }
}
