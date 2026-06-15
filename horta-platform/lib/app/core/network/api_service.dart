import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../configs/config_service.dart';

class ApiService {
  late final Dio _dio;
  final FlutterSecureStorage _storage;

  ApiService({
    required FlutterSecureStorage storage,
    required IConfigsService configsService,
  }) : _storage = storage {
    _dio = Dio(BaseOptions(
      baseUrl: configsService.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'jwt_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          await _storage.delete(key: 'jwt_token');
        }
        debugPrint('[ApiService] Error: ${error.message}');
        return handler.next(error);
      },
    ));
  }

  Dio get client => _dio;
}
