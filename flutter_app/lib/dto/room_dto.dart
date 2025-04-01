
import 'package:flutter_app/dto/user_dto.dart';

class RoomDTO {
  final int roomId;
  final String title;
  final String description;
  final int capacity;
  final String createdAt;

  final UserDTO host;
  


  RoomDTO({
    required this.roomId,
    required this.title,
    required this.description,
    required this.capacity,
    required this.createdAt,
    required this.host,
  });

  factory RoomDTO.fromJson(Map<String, dynamic> json) {
    return RoomDTO(
      roomId: json['roomId'],
      title: json['title'],
      description: json['description'],
      capacity: json['capacity'],
      createdAt: json['createdAt'],
      host: UserDTO.fromJson(json['host']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'title': title,
      'description': description,
      'capacity': capacity,
      'createdAt': createdAt,
      'host': host.toJson(),
      
    };
  }
}
