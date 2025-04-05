import 'package:flutter_app/dto/message_info_dto.dart';

class GetMessageResponseDto {
  final List<MessageInfoDto> chatMessages;

  GetMessageResponseDto({required this.chatMessages});

  factory GetMessageResponseDto.fromJson(Map<String, dynamic> json) {
    return GetMessageResponseDto(
      chatMessages:
          (json['chatMessages'] as List)
              .map((e) => MessageInfoDto.fromJson(e))
              .toList(),
    );
  }
}
