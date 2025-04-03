class RoomDTO {
  final int roomId;
  final String title;
  final String description;
  final int capacity;
  final String createdAt;

  final String hostUserId;

  RoomDTO({
    required this.roomId,
    required this.title,
    required this.description,
    required this.capacity,
    required this.createdAt,
    required this.hostUserId,
  });

  factory RoomDTO.fromJson(Map<String, dynamic> json) {
    return RoomDTO(
      roomId: json['roomId'],
      title: json['title'],
      description: json['description'],
      capacity: json['capacity'],
      createdAt: json['createdAt'],
      hostUserId: json['hostUserId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'title': title,
      'description': description,
      'capacity': capacity,
      'createdAt': createdAt,
      'hostUserId': hostUserId,
    };
  }
}
