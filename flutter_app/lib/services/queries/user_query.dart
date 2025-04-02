import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/dto/user_dto.dart';
import 'package:flutter_app/dto/user_update_dto.dart';
import 'package:flutter_app/dto/user_update_interest_dto.dart';
import 'package:flutter_app/services/url.dart';
import 'package:http/http.dart' as http;

//로그인 후 유저 정보 조회
Future<({bool success, String message, UserDTO? user})> loginUser() async {
  String? idToken;
  try {
    idToken = await FirebaseAuth.instance.currentUser!.getIdToken(true);
  }
  catch (e){
    return (success: false, message: "firebase failure $e", user: null);
  }

  if (idToken == null) {
    return (success: false, message: "token failure", user: null);
  }

  final response = await http.post(
    url('/api/users/login'),
    headers: {
      'Authorization': 'Bearer $idToken',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode != 200) {
    return (
      success: false,
      message: "server failure: $response.body",
      user: null,
    );
  }

  try {
    return (
      success: true,
      message: "succeed",
      user: UserDTO.fromJson(
        jsonDecode(response.body)['data']?['user']?['userInfo'],
      ),
    );
  } catch (e) {
    return (success: false, message: "parsing failure: $e", user: null);
  }
}

// 현재 유저 정보
Future<({bool success, String message, UserDTO? user})> getUser() async {
  String? idToken;
  try {
    idToken = await FirebaseAuth.instance.currentUser!.getIdToken(true);
  }
  catch (e){
    return (success: false, message: "firebase failure $e", user: null);
  }

  if (idToken == null) {
    return (success: false, message: "token failure", user: null);
  }

  final response = await http.get(
    url('/api/users/profile'),
    headers: {
      'Authorization': 'Bearer $idToken',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode != 200) {
    return (
      success: false,
      message: "server failure: ${response.body}",
      user: null,
    );
  }

  try {
    return (
      success: true,
      message: "succeed",
      user: UserDTO.fromJson(jsonDecode(response.body)['data']?['user']),
    );
  } catch (e) {
    return (success: false, message: "parsing failure: $e", user: null);
  }
}

// 유저 정보 업데이트
Future<({bool success, String message})> updateUser() async {
  String? idToken;
  try {
    idToken = await FirebaseAuth.instance.currentUser!.getIdToken(true);
  }
  catch (e){
    return (success: false, message: "firebase failure $e");
  }

  if (idToken == null) {
    return (success: false, message: "token failure");
  }

  final response = await http.patch(
    url('/api/users/profile'),
    headers: {
      'Authorization': 'Bearer $idToken',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(UserUpdateDTO.instance.toJson()),
  );

  if (response.statusCode != 200) {
    return (success: false, message: "server failure: ${response.body}");
  }

  return (success: true, message: "succeed");
}

Future<({bool success, String message, String? introText})> updateUserInterest() async {
  String? idToken;
  try {
    idToken = await FirebaseAuth.instance.currentUser!.getIdToken(true);
  }
  catch (e){
    return (success: false, message: "firebase failure $e", introText: null);
  }

  if (idToken == null) {
    return (success: false, message: "token failure", introText: null);
  }

  final response = await http.put(
    url('/api/users/interests'),
    headers: {
      'Authorization': 'Bearer $idToken',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(UserUpdateInterestIntroDTO.instance.toInterestJson()),
  );

  if (response.statusCode != 200) {
    return (success: false, message: "server failure: ${response.body}", introText: null);
  }

  try {
    final String text = jsonDecode(response.body)['data']['generatedIntroText'];
    return (
    success: true,
    message: "succeed",
    introText: text);
  } catch (e) {
    return (success: false, message: "parsing failure: $e", introText: null);
  }
}

Future<({bool success, String message})> updateUserIntro() async {
  String? idToken;
  try {
    idToken = await FirebaseAuth.instance.currentUser!.getIdToken(true);
  }
  catch (e){
    return (success: false, message: "firebase failure $e");
  }

  if (idToken == null) {
    return (success: false, message: "token failure");
  }

  final response = await http.put(
    url('/api/users/intro'),
    headers: {
      'Authorization': 'Bearer $idToken',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(UserUpdateInterestIntroDTO.instance.toIntroJson()),
  );

  if (response.statusCode != 200) {
    return (success: false, message: "server failure: ${response.body}");
  }

  return (success: true, message: "succeed");
}
