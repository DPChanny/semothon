class UnreadMessageCountDto {
  final int chatRoomId;
  final int unreadCount;

  UnreadMessageCountDto({required this.chatRoomId, required this.unreadCount});

  factory UnreadMessageCountDto.fromJson(Map<String, dynamic> json) {
    return UnreadMessageCountDto(
      chatRoomId: json['chatRoomId'],
      unreadCount: json['unreadCount'],
    );
  }
}
