import 'package:flutter_app/dto/user_dto.dart';
import 'package:flutter_app/services/dummy_users.dart';

Future<List<UserDTO>> fetchMentors() async {
  await Future.delayed(Duration(seconds: 1));
  return randomUsers(3);
}
