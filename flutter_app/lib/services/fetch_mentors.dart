import '../dto/user_dto.dart';
import 'dummy_users.dart';

Future<List<UserDTO>> fetchMentors() async {
  await Future.delayed(Duration(seconds: 1));
  return randomUsers(3);
}