class UnreadMessageCountDTO {
  final int chatRoomId;
  final int unreadCount;

  UnreadMessageCountDTO({required this.chatRoomId, required this.unreadCount});

  factory UnreadMessageCountDTO.fromJson(Map<String, dynamic> json) {
    return UnreadMessageCountDTO(
      chatRoomId: json['chatRoomId'],
      unreadCount: json['unreadCount'],
    );
  }
}
