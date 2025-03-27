// class UserDto {
//   final String name;
//   final int age;
//
//   UserDto({required this.name, required this.age});
//
//   // JSON → 객체
//   factory UserDto.fromJson(Map<String, dynamic> json) {
//     return UserDto(
//       name: json['name'],
//       age: json['age'],
//     );
//   }
//
//   // 객체 → JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'age': age,
//     };
//   }
// }

//dto 예시