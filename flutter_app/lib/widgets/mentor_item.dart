// import 'package:flutter/material.dart';
//
// Widget mentorItem(Mentor mentor) {
//
//   return Container(
//     margin: const EdgeInsets.only(bottom: 12),
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         CircleAvatar(
//           radius: 24,
//           backgroundImage: NetworkImage(mentor.imageUrl),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 mentor.name,
//                 style: const TextStyle(
//                   fontFamily: 'Noto Sans KR',
//                   fontWeight: FontWeight.w400,
//                   letterSpacing: -0.29,
//                   fontSize: 17,
//                 ),
//               ),
//               Text(
//                 mentor.description,
//                 style: const TextStyle(
//                   color: Color(0xFF888888),
//                   fontSize: 12,
//                   fontFamily: 'Noto Sans KR',
//                   fontWeight: FontWeight.w400,
//                   letterSpacing: -0.20,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(width: 12),
//         ElevatedButton(
//           onPressed: () {},
//           child: const Text('알아보기'),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFFE0E0E0),
//             foregroundColor: Colors.black,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           ),
//         )
//       ],
//     ),
//   );
// }