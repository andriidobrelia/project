import 'dart:async';

import 'package:dio/dio.dart';

typedef OnParse<T> = FutureOr<T> Function(Response);

abstract class NetworkService {
  factory NetworkService() => _NetworkServiceImpl();

  Future<T?> getRequest<T>(
    String path, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    OnParse<T>? onParse,
  });

  Future<T?> postRequest<T>(
    String path, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    OnParse<T>? onParse,
  });

  Future<T?> request<T>(
    String path,
    String method, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    OnParse<T>? onParse,
  });
}

class _NetworkServiceImpl implements NetworkService {
  _NetworkServiceImpl() : _dio = Dio(BaseOptions());

  final Dio _dio;

  @override
  Future<T?> getRequest<T>(
    String path, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    OnParse<T>? onParse,
  }) async {
    return request(
      path,
      'GET',
      queryParameters: queryParameters,
      onParse: onParse,
      headers: headers,
    );
  }

  @override
  Future<T?> postRequest<T>(
    String path, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    OnParse<T>? onParse,
    bool retry = false,
  }) async {
    return request(
      path,
      'POST',
      queryParameters: queryParameters,
      onParse: onParse,
      headers: headers,
    );
  }

  @override
  Future<T?> request<T>(
    String path,
    String method, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    OnParse<T>? onParse,
  }) async {
    try {
      final options = Options()
        ..method = method
        ..headers = headers ?? <String, dynamic>{};
      final response = await _dio.request(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return onParse == null ? response.data : onParse(response);
    } on DioError catch (e) {
      print('ERROR: $e');
    }
    return null;
  }
}
