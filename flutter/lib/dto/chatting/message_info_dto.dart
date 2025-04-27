class MessageInfoDTO {
  final int chatMessageId;
  final int chatRoomId;
  final String senderId;
  final String senderNickname;
  final String senderProfileImageUrl;
  final String message;
  final String? imageUrl;
  final DateTime createdAt;

  MessageInfoDTO({
    required this.chatMessageId,
    required this.chatRoomId,
    required this.senderId,
    required this.senderNickname,
    required this.senderProfileImageUrl,
    required this.message,
    this.imageUrl,
    required this.createdAt,
  });

  factory MessageInfoDTO.fromJson(Map<String, dynamic> json) {
    return MessageInfoDTO(
      chatMessageId: json['chatMessageId'],
      chatRoomId: json['chatRoomId'],
      senderId: json['senderId'],
      senderNickname: json['senderNickname'],
      senderProfileImageUrl: json['senderProfileImageUrl'],
      message: json['message'],
      imageUrl: json['imageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatMessageId': chatMessageId,
      'chatRoomId': chatRoomId,
      'senderId': senderId,
      'senderNickname': senderNickname,
      'senderProfileImageUrl': senderProfileImageUrl,
      'message': message,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
