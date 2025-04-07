class RoomInfoDto {
  final int roomId;
  final String title;
  final String description;
  final int capacity;
  final DateTime createdAt;
  final int currentMemberCount;
  final int? chatRoomId;
  final List<String> interests;
  final String profileImageUrl;

  RoomInfoDto({
    required this.roomId,
    required this.title,
    required this.description,
    required this.capacity,
    required this.createdAt,
    required this.currentMemberCount,
    required this.chatRoomId,
    required this.interests,
    required this.profileImageUrl,
  });

  factory RoomInfoDto.fromJson(Map<String, dynamic> json) {
    return RoomInfoDto(
      roomId: json['roomId'],
      title: json['title'],
      description: json['description'],
      capacity: json['capacity'],
      createdAt: DateTime.parse(json['createdAt']),
      currentMemberCount: json['currentMemberCount'],
      chatRoomId: json['chatRoomId'],
      interests: List<String>.from(json['interests']),
      profileImageUrl: json['profileImageUrl'],
    );
  }
}
