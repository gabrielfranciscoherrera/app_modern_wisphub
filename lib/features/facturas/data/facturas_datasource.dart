import 'package:dio/dio.dart';
import '../../../core/errors/api_exception.dart';
import '../models/factura_model.dart';

class FacturasDatasource {
  final Dio _dio;
  FacturasDatasource(this._dio);

  Future<List<Factura>> list({
    String? fechaDesde,
    String? fechaHasta,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final now = DateTime.now();
      final desde = fechaDesde ??
          '${now.year}-${now.month.toString().padLeft(2, '0')}-01';
      final hasta = fechaHasta ??
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      final response = await _dio.get(
        '/facturas/',
        queryParameters: {
          'fecha_emision_desde': desde,
          'fecha_emision_hasta': hasta,
          'limit': limit,
          'offset': offset,
        },
      );
      final results = response.data['results'] as List<dynamic>? ?? [];
      return results
          .map((e) => Factura.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : ApiException.fromDioError(e);
    }
  }

  Future<Factura> retrieve(int idFactura) async {
    try {
      final response = await _dio.get('/facturas/$idFactura/');
      return Factura.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : ApiException.fromDioError(e);
    }
  }

  Future<void> registrarPago({
    required int idFactura,
    required double monto,
    required int idFormaPago,
  }) async {
    try {
      await _dio.post(
        '/facturas/$idFactura/registrar-pago/',
        data: {'monto': monto, 'id_forma_pago': idFormaPago},
      );
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : ApiException.fromDioError(e);
    }
  }
}
