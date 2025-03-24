class TestModel {
  final String result;

  TestModel({required this.result});

  factory TestModel.fromJson(Map<String, dynamic> json) {
    return TestModel(result: json['result'] ?? '결과 없음');
  }
}
