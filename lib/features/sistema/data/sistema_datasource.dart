import 'package:dio/dio.dart';
import '../../../core/errors/api_exception.dart';
import '../models/sistema_models.dart';

class SistemaDatasource {
  final Dio _dio;
  SistemaDatasource(this._dio);

  Future<List<T>> _getList<T>(
    String path,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final response = await _dio.get(path);
      final data = response.data;
      final list = data is Map ? (data['results'] ?? data) : data;
      return (list as List<dynamic>)
          .map((e) => fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : ApiException.fromDioError(e);
    }
  }

  Future<List<PlanInternet>> planes() =>
      _getList('/plan-internet/', PlanInternet.fromJson);

  Future<List<Zona>> zonas() => _getList('/zonas/', Zona.fromJson);

  Future<List<Router>> routers() => _getList('/router/', Router.fromJson);
}
