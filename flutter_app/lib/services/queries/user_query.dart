import 'package:flutter_app/dto/get_user_list_response_dto.dart';
import 'package:flutter_app/dto/get_user_response_dto.dart';
import 'package:flutter_app/dto/user_info_dto.dart';
import 'package:flutter_app/dto/user_update_dto.dart';
import 'package:flutter_app/dto/user_update_interest_dto.dart';
import 'package:flutter_app/services/queries/query.dart';

Future<UserInfoDto> loginUser() {
  return queryPost<UserInfoDto>(
    '/api/users/login',
    fromJson: (json) => UserInfoDto.fromJson(json['user']),
  );
}

Future<GetUserResponseDto> getUser() {
  return queryGet<GetUserResponseDto>(
    '/api/users/profile',
        (json) => GetUserResponseDto.fromJson(json),
  );
}

Future<GetUserResponseDto> getOtherUser(String userId) {
  return queryGet<GetUserResponseDto>(
    '/api/users/profile/$userId',
        (json) => GetUserResponseDto.fromJson(json),
  );
}

Future<void> updateUser() {
  return queryPatch<void>(
    '/api/users/profile',
    body: UserUpdateDTO.instance.toJson(),
  );
}

Future<String> updateUserInterest() {
  return queryPut<String>(
    '/api/users/interests',
    body: UserUpdateInterestIntroDTO.instance.toInterestJson(),
    fromJson: (json) => json['generatedIntroText'],
  );
}

Future<void> updateUserIntro() {
  return queryPut<void>(
    '/api/users/intro',
    body: UserUpdateInterestIntroDTO.instance.toIntroJson(),
  );
}

Future<GetUserListResponseDto> getUserList({
  String? nicknameKeyword,
  String? departmentKeyword,
  String? introKeyword,
  String? nameKeyword,
  String? keyword,
  String? birthdateAfter,
  String? birthdateBefore,
  List<String>? interestNames,
  double? minRecommendationScore,
  double? maxRecommendationScore,
  String? createdAfter,
  String? createdBefore,
  String? sortBy,
  String? sortDirection,
  int? limit,
  int? page,
}) {
  final queryParams = <String, dynamic>{
    if (nicknameKeyword != null) 'nicknameKeyword': nicknameKeyword,
    if (departmentKeyword != null) 'departmentKeyword': departmentKeyword,
    if (introKeyword != null) 'introKeyword': introKeyword,
    if (nameKeyword != null) 'nameKeyword': nameKeyword,
    if (keyword != null) 'keyword': keyword,
    if (birthdateAfter != null) 'birthdateAfter': birthdateAfter,
    if (birthdateBefore != null) 'birthdateBefore': birthdateBefore,
    if (interestNames != null && interestNames.isNotEmpty) 'interestNames': interestNames,
    if (minRecommendationScore != null) 'minRecommendationScore': minRecommendationScore,
    if (maxRecommendationScore != null) 'maxRecommendationScore': maxRecommendationScore,
    if (createdAfter != null) 'createdAfter': createdAfter,
    if (createdBefore != null) 'createdBefore': createdBefore,
    if (sortBy != null) 'sortBy': sortBy,
    if (sortDirection != null) 'sortDirection': sortDirection,
    if (limit != null) 'limit': limit,
    if (page != null) 'page': page,
  };

  return queryGet<GetUserListResponseDto>(
    '/api/users',
        (json) => GetUserListResponseDto.fromJson(json),
    queryParams: queryParams,
  );
}

Future<void> deleteUser() {
  return queryDelete<void>(
    '/api/users/prifile',
  );
}
