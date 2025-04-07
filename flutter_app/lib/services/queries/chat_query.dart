import 'package:flutter_app/dto/wrapper/chatting/get_chat_list_response_dto.dart';
import 'package:flutter_app/dto/wrapper/chatting/get_chat_response_dto.dart';
import 'package:flutter_app/dto/wrapper/chatting/get_message_response_dto.dart';
import 'package:flutter_app/dto/wrapper/chatting/get_unread_message_count_response_dto.dart';
import 'package:flutter_app/services/queries/query.dart';

Future<GetChatListResponseDto> getChatList({
  List<String>? titleKeyword,
  List<String>? descriptionKeyword,
  List<String>? titleOrDescriptionKeyword,
  String? hostUserId,
  String? hostNickname,
  List<String>? interestNames,
  int? minCapacity,
  int? maxCapacity,
  double? minRecommendationScore,
  double? maxRecommendationScore,
  bool? joinedOnly,
  bool? excludeJoined,
  String? createdAfter,
  String? createdBefore,
  String? sortBy,
  String? sortDirection,
  int? limit,
  int? page,
}) {
  final queryParams = <String, dynamic>{
    if (titleKeyword != null && titleKeyword.isNotEmpty)
      'titleKeyword': titleKeyword,
    if (descriptionKeyword != null && descriptionKeyword.isNotEmpty)
      'descriptionKeyword': descriptionKeyword,
    if (titleOrDescriptionKeyword != null &&
        titleOrDescriptionKeyword.isNotEmpty)
      'titleOrDescriptionKeyword': titleOrDescriptionKeyword,
    if (hostUserId != null) 'hostUserId': hostUserId,
    if (hostNickname != null) 'hostNickname': hostNickname,
    if (interestNames != null && interestNames.isNotEmpty)
      'interestNames': interestNames,
    if (minCapacity != null) 'minCapacity': minCapacity,
    if (maxCapacity != null) 'maxCapacity': maxCapacity,
    if (minRecommendationScore != null)
      'minRecommendationScore': minRecommendationScore,
    if (maxRecommendationScore != null)
      'maxRecommendationScore': maxRecommendationScore,
    if (joinedOnly != null) 'joinedOnly': joinedOnly,
    if (excludeJoined != null) 'excludeJoined': excludeJoined,
    if (createdAfter != null) 'createdAfter': createdAfter,
    if (createdBefore != null) 'createdBefore': createdBefore,
    if (sortBy != null) 'sortBy': sortBy,
    if (sortDirection != null) 'sortDirection': sortDirection,
    if (limit != null) 'limit': limit,
    if (page != null) 'page': page,
  };

  return queryGet<GetChatListResponseDto>(
    '/api/chats',
    (json) => GetChatListResponseDto.fromJson(json),
    queryParams: queryParams,
  );
}

Future<GetMessageResponseDto> getChatMessage(int chatRoomId) {
  return queryGet<GetMessageResponseDto>(
    'api/chats/$chatRoomId/messages',
    (json) => GetMessageResponseDto.fromJson(json),
  );
}

Future<GetChatResponseDto> getChat(int chatId) {
  return queryGet<GetChatResponseDto>(
    'api/chats/$chatId',
    (json) => GetChatResponseDto.fromJson(json),
  );
}

Future<GetUnreadMessageCountResponseDto> getUnreadMessageCount() {
  return queryGet<GetUnreadMessageCountResponseDto>(
    'api/chats/unread-count',
    (json) => GetUnreadMessageCountResponseDto.fromJson(json),
  );
}
