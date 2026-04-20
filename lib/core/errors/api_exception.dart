import 'package:dio/dio.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;

  const ApiException({required this.statusCode, required this.message});

  factory ApiException.fromDioError(DioException e) {
    final code = e.response?.statusCode ?? 0;
    final data = e.response?.data;
    String msg;

    if (data is Map && data.containsKey('detail')) {
      msg = data['detail'].toString();
    } else {
      msg = switch (code) {
        400 => 'Solicitud incorrecta.',
        401 => 'No autenticado. Verifica tu API Key.',
        403 => 'Sin permisos para este recurso.',
        404 => 'Recurso no encontrado.',
        422 => 'No se pudo procesar la solicitud.',
        500 => 'Error interno del servidor WispHub.',
        _ => e.message ?? 'Error de red desconocido.',
      };
    }

    return ApiException(statusCode: code, message: msg);
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}
