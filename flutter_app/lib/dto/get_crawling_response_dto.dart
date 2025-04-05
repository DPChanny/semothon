import 'package:flutter_app/dto/chat_room_info_dto.dart';
import 'package:flutter_app/dto/crawling_info_dto.dart';
import 'package:flutter_app/dto/host_user_info_dto.dart';
import 'package:flutter_app/dto/room_user_info_dto.dart';

class GetCrawlingResponseDto {
  final CrawlingInfoDto crawlingInfo;
  final ChatRoomInfoDto chatRooms;
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
      chatRooms: ChatRoomInfoDto.fromJson(json['chatRooms']['chatRoomInfo']),
      members:
          (json['chatRooms']['members'] as List<dynamic>)
              .map((e) => RoomUserInfoDto.fromJson(e))
              .toList(),
      host: HostUserInfoDto.fromJson(json['chatRooms']['host']),
    );
  }
}
