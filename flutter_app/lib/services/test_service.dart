import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/test_model.dart';

class TestService {
  static Future<TestModel> test() async {
    final response = await http.get(Uri.parse("http://localhost:8080/api/test"));
    if (response.statusCode == 200) {
      return TestModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("request failled: \${response.statusCode}");
    }
  }
}
