import 'package:dio/dio.dart';
import '../../../core/errors/api_exception.dart';
import '../models/cliente_model.dart';

class ClientesDatasource {
  final Dio _dio;
  ClientesDatasource(this._dio);

  Future<List<Cliente>> list({int limit = 50, int offset = 0}) async {
    try {
      final response = await _dio.get(
        '/clientes/',
        queryParameters: {'limit': limit, 'offset': offset},
      );
      final results = response.data['results'] as List<dynamic>? ?? [];
      return results
          .map((e) => Cliente.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : ApiException.fromDioError(e);
    }
  }

  Future<Cliente> retrieve(int idServicio) async {
    try {
      final response = await _dio.get('/clientes/$idServicio/');
      return Cliente.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : ApiException.fromDioError(e);
    }
  }

  Future<SaldoCliente> saldo(int idServicio) async {
    try {
      final response = await _dio.get('/clientes/$idServicio/saldo/');
      return SaldoCliente.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : ApiException.fromDioError(e);
    }
  }

  Future<void> activar(int idServicio) async {
    try {
      await _dio.post('/clientes/activar/', data: {'id_servicio': idServicio});
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : ApiException.fromDioError(e);
    }
  }

  Future<void> desactivar(int idServicio) async {
    try {
      await _dio.post(
        '/clientes/desactivar/',
        data: {'id_servicio': idServicio},
      );
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : ApiException.fromDioError(e);
    }
  }
}
