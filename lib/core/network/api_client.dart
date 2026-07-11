import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:dosen/core/constants/api_config.dart';
import 'package:dosen/core/network/api_exception.dart';
import 'package:dosen/core/services/session_service.dart';

class ApiClient {
  ApiClient._internal();

  static final ApiClient instance = ApiClient._internal();

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    final normalized = path.startsWith('/') ? path : '/$path';
    return Uri.parse('${ApiConfig.baseUrl}$normalized').replace(
      queryParameters: query?.map((key, value) => MapEntry(key, value.toString())),
    );
  }

  Map<String, String> _headers({bool json = true}) {
    final headers = <String, String>{};
    if (json) headers['Content-Type'] = 'application/json';
    headers['Accept'] = 'application/json';
    final token = SessionService.instance.token;
    if (token != null) headers['Authorization'] = 'Bearer $token';
    return headers;
  }

  dynamic _decode(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return json.decode(response.body);
    }

    Map<String, dynamic> body = {};
    try {
      body = json.decode(response.body) as Map<String, dynamic>;
    } catch (_) {}

    throw ApiException(
      body['message']?.toString() ?? 'Terjadi kesalahan (${response.statusCode})',
      statusCode: response.statusCode,
      fieldErrors: body['errors'] as Map<String, dynamic>?,
    );
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) async {
    final response = await http.get(_uri(path, query), headers: _headers());
    return _decode(response);
  }

  Future<dynamic> post(String path, {Map<String, dynamic>? body}) async {
    final response = await http.post(
      _uri(path),
      headers: _headers(),
      body: body != null ? json.encode(body) : null,
    );
    return _decode(response);
  }

  Future<dynamic> put(String path, {Map<String, dynamic>? body}) async {
    final response = await http.put(
      _uri(path),
      headers: _headers(),
      body: body != null ? json.encode(body) : null,
    );
    return _decode(response);
  }

  Future<dynamic> delete(String path) async {
    final response = await http.delete(_uri(path), headers: _headers());
    return _decode(response);
  }

  Future<String> uploadFile(String localFilePath, {String folder = 'general'}) async {
    final request = http.MultipartRequest('POST', _uri('/uploads'));
    request.headers.addAll(_headers(json: false));
    request.fields['folder'] = folder;
    request.files.add(await http.MultipartFile.fromPath('file', localFilePath));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    final decoded = _decode(response) as Map<String, dynamic>;
    return decoded['url'] as String;
  }
}
