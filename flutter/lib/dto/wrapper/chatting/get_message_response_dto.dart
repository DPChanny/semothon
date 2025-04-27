import 'package:flutter_app/dto/chatting/message_info_dto.dart';

class GetMessageResponseDto {
  final List<MessageInfoDTO> chatMessages;

  GetMessageResponseDto({required this.chatMessages});

  factory GetMessageResponseDto.fromJson(Map<String, dynamic> json) {
    return GetMessageResponseDto(
      chatMessages:
          (json['chatMessages'] as List)
              .map((e) => MessageInfoDTO.fromJson(e))
              .toList(),
    );
  }
}
