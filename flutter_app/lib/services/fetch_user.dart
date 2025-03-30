import '../dto/user_dto.dart';
import 'dummy_users.dart';

/// 🔹 유저 정보 + 키워드 더미 데이터를 비동기로 반환
Future<(UserDTO, List<String>)> fetchUser() async {
  await Future.delayed(const Duration(seconds: 1)); // 로딩 시뮬레이션

  final keywords = ['UX', 'UI', '디자인', 'Flutter', '프론트엔드',];

  return (randomUsers(1)[0], keywords);
}
