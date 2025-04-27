import 'dart:convert';

import 'package:flutter_app/services/auth.dart';
import 'package:flutter_app/services/url.dart';
import 'package:http/http.dart' as http;

Future<T> queryGet<T>(
  String path,
  T Function(Map<String, dynamic>) fromJson, {
  Map<String, dynamic>? queryParams,
  int expectedStatusCode = 200,
}) async {
  final idToken = await getIdToken();
  if (idToken == null) throw Exception("token failure");

  final response = await http.get(
    url(path, queryParams: queryParams),
    headers: {
      'Authorization': 'Bearer $idToken',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode != expectedStatusCode) {
    throw Exception("server failure: ${response.body}");
  }

  final decoded = jsonDecode(utf8.decode(response.bodyBytes));
  return fromJson(decoded['data']);
}

Future<T> queryPost<T>(
  String path, {
  dynamic body,
  Map<String, dynamic>? queryParams,
  T Function(Map<String, dynamic>)? fromJson,
  int expectedStatusCode = 200,
}) async {
  final idToken = await getIdToken();
  if (idToken == null) throw Exception("token failure");

  final response = await http.post(
    url(path, queryParams: queryParams),
    headers: {
      'Authorization': 'Bearer $idToken',
      'Content-Type': 'application/json',
    },
    body: body != null ? jsonEncode(body is Map ? body : body.toJson()) : null,
  );

  if (response.statusCode != expectedStatusCode) {
    throw Exception("server failure: ${response.body}");
  }

  if (fromJson != null) {
    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    return fromJson(decoded['data']);
  } else {
    return Future.value() as T;
  }
}

Future<T> queryPut<T>(
  String path, {
  dynamic body,
  Map<String, dynamic>? queryParams,
  T Function(Map<String, dynamic>)? fromJson,
  int expectedStatusCode = 200,
}) async {
  final idToken = await getIdToken();
  if (idToken == null) throw Exception("token failure");

  final response = await http.put(
    url(path, queryParams: queryParams),
    headers: {
      'Authorization': 'Bearer $idToken',
      'Content-Type': 'application/json',
    },
    body: body != null ? jsonEncode(body is Map ? body : body.toJson()) : null,
  );

  if (response.statusCode != expectedStatusCode) {
    throw Exception("server failure: ${response.body}");
  }

  if (fromJson != null) {
    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    return fromJson(decoded['data']);
  } else {
    return Future.value() as T;
  }
}

Future<T> queryPatch<T>(
  String path, {
  dynamic body,
  Map<String, dynamic>? queryParams,
  T Function(Map<String, dynamic>)? fromJson,
  int expectedStatusCode = 200,
}) async {
  final idToken = await getIdToken();
  if (idToken == null) throw Exception("token failure");

  final response = await http.patch(
    url(path, queryParams: queryParams),
    headers: {
      'Authorization': 'Bearer $idToken',
      'Content-Type': 'application/json',
    },
    body: body != null ? jsonEncode(body is Map ? body : body.toJson()) : null,
  );

  if (response.statusCode != expectedStatusCode) {
    throw Exception("server failure: ${response.body}");
  }

  if (fromJson != null) {
    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    return fromJson(decoded['data']);
  } else {
    return Future.value() as T;
  }
}

Future<T> queryDelete<T>(
  String path, {
  Map<String, dynamic>? queryParams,
  int expectedStatusCode = 200,
  T Function(Map<String, dynamic>)? fromJson,
}) async {
  final idToken = await getIdToken();
  if (idToken == null) throw Exception("token failure");

  final response = await http.delete(
    url(path, queryParams: queryParams),
    headers: {
      'Authorization': 'Bearer $idToken',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode != expectedStatusCode) {
    throw Exception("server failure: ${response.body}");
  }

  if (fromJson != null) {
    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    return fromJson(decoded['data']);
  } else {
    return Future.value() as T;
  }
}
