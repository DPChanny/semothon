import 'package:flutter_app/dto/user_dto.dart';
import 'package:flutter_app/services/dummy_users.dart';

Future<(UserDTO, List<String>)> fetchUser() async {
  await Future.delayed(const Duration(seconds: 1));

  final keywords = ['UX', 'UI', '디자인', 'Flutter', '프론트엔드'];

  return (randomUsers(1)[0], keywords);
}
