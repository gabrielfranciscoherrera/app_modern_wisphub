import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_settings.dart';
import '../errors/api_exception.dart';

final apiClientProvider = Provider<Dio>((ref) {
  throw UnimplementedError('Override apiClientProvider before use');
});

Future<Dio> buildApiClient() async {
  final apiKey = await AppSettings.getApiKey() ?? '';
  final baseUrl = await AppSettings.getBaseUrl() ?? 'https://api.wisphub.net/api/';

  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Api-Key $apiKey',
      },
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onError: (DioException e, handler) {
        handler.reject(
          DioException(
            requestOptions: e.requestOptions,
            error: ApiException.fromDioError(e),
            response: e.response,
            type: e.type,
          ),
        );
      },
    ),
  );

  return dio;
}
