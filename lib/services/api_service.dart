import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_flutter/router/router_name.dart';
import 'package:todo_flutter/services/token_service.dart';

enum Method {
  get,
  post,
  put,
  delete,
}

class ApiService {
  final BuildContext _context;
  final TokenService _tokenService;
  final bool _useToken;

  ApiService({
    required BuildContext context,
    required TokenService tokenService,
    bool? useToken,
  })  : _context = context,
        _tokenService = tokenService,
        _useToken = useToken ?? true;

  Future<Response> get(String path) async {
    return await _request(
      path: path,
      method: Method.get,
    );
  }

  Future<Response> post(String path, Map<String, dynamic> data) async {
    return await _request(
      path: path,
      method: Method.post,
      data: data,
    );
  }

  Future<Response> put(String path, Map<String, dynamic> data) async {
    return await _request(
      path: path,
      method: Method.put,
      data: data,
    );
  }

  Future<Response> delete(String path) async {
    return await _request(
      path: path,
      method: Method.delete,
    );
  }

  Future<Response> _request({
    required String path,
    required Method method,
    Map<String, dynamic>? data,
  }) async {
    final headers = await _headers();
    late final http.Response response;

    switch (method) {
      case Method.get:
        response = await http.get(
          _uri(path),
          headers: headers,
        );
      case Method.post:
        response = await http.post(
          _uri(path),
          headers: headers,
          body: data,
        );
      case Method.put:
        response = await http.put(
          _uri(path),
          headers: headers,
          body: data,
        );
      case Method.delete:
        response = await http.delete(
          _uri(path),
          headers: headers,
        );
    }

    if (response.statusCode == 401 && _context.mounted) {
      Navigator.of(_context).pushReplacementNamed(LOGIN_PAGE);

      throw UnauthorizedException(
        message: jsonDecode(response.body)['message'],
      );
    }

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw ApiServiceException(
        message: jsonDecode(response.body)['message'],
      );
    }

    return Response(response);
  }

  Uri _uri(String path) {
    return Uri(
      scheme: 'http',
      host: '192.168.10.179',
      port: 8080,
      path: path,
    );
  }

  Future<Map<String, String>?> _headers() async {
    if (!_useToken) return null;

    final authInfo = await _tokenService.get();

    return {
      'Authorization': 'Bearer ${authInfo?.token}',
      'Content-Type': 'application/json',
    };
  }
}

class Response {
  final http.Response _response;

  Response(this._response);

  int get statusCode => _response.statusCode;
  Map<String, dynamic> get data => _decodeBody();

  Map<String, dynamic> _decodeBody() {
    try {
      return jsonDecode(_response.body);
    } catch (e) {
      throw ApiServiceException(message: 'Invalid response body');
    }
  }
}

class ApiServiceException implements Exception {
  final String message;

  ApiServiceException({required this.message});
}

class UnauthorizedException implements ApiServiceException {
  @override
  final String message;

  UnauthorizedException({required this.message});
}
