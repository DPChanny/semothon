import 'package:flutter_app/dto/chatting/chat_room_info_dto.dart';
import 'package:flutter_app/dto/crawling/crawling_info_dto.dart';
import 'package:flutter_app/dto/user/host_user_info_dto.dart';
import 'package:flutter_app/dto/user/room_user_info_dto.dart';

class GetCrawlingResponseDto {
  final CrawlingInfoDto crawlingInfo;
  final ChatRoomInfoDTO chatRooms;
  final List<RoomUserInfoDto> members;
  final HostUserInfoDto host;

  GetCrawlingResponseDto({
    required this.crawlingInfo,
    required this.chatRooms,
    required this.members,
    required this.host,
  });

  factory GetCrawlingResponseDto.fromJson(Map<String, dynamic> json) {
    return GetCrawlingResponseDto(
      crawlingInfo: CrawlingInfoDto.fromJson(json['crawlingInfo']),
      chatRooms: ChatRoomInfoDTO.fromJson(json['chatRooms']['chatRoomInfo']),
      members:
          (json['chatRooms']['members'] as List<dynamic>)
              .map((e) => RoomUserInfoDto.fromJson(e))
              .toList(),
      host: HostUserInfoDto.fromJson(json['chatRooms']['host']),
    );
  }
}
