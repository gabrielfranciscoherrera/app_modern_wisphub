import 'package:dio/dio.dart';
import '../../../core/errors/api_exception.dart';
import '../models/ticket_model.dart';

class TicketsDatasource {
  final Dio _dio;
  TicketsDatasource(this._dio);

  Future<List<Ticket>> list({int limit = 50, int offset = 0}) async {
    try {
      final response = await _dio.get(
        '/tickets/',
        queryParameters: {'limit': limit, 'offset': offset},
      );
      final results = response.data['results'] as List<dynamic>? ?? [];
      return results
          .map((e) => Ticket.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : ApiException.fromDioError(e);
    }
  }

  Future<Ticket> retrieve(int idTicket) async {
    try {
      final response = await _dio.get('/tickets/$idTicket/');
      return Ticket.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : ApiException.fromDioError(e);
    }
  }
}
