import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../data/sistema_datasource.dart';
import '../models/sistema_models.dart';

final sistemaDatasourceProvider = Provider<SistemaDatasource>((ref) {
  return SistemaDatasource(ref.read(apiClientProvider));
});

final planesProvider = FutureProvider<List<PlanInternet>>((ref) {
  return ref.read(sistemaDatasourceProvider).planes();
});

final zonasProvider = FutureProvider<List<Zona>>((ref) {
  return ref.read(sistemaDatasourceProvider).zonas();
});

final routersProvider = FutureProvider<List<Router>>((ref) {
  return ref.read(sistemaDatasourceProvider).routers();
});
