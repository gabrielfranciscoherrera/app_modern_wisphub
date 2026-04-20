import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../data/facturas_datasource.dart';
import '../models/factura_model.dart';

final facturasDatasourceProvider = Provider<FacturasDatasource>((ref) {
  return FacturasDatasource(ref.read(apiClientProvider));
});

final facturasListProvider = FutureProvider.family<List<Factura>, int>(
  (ref, page) {
    return ref
        .read(facturasDatasourceProvider)
        .list(limit: 50, offset: page * 50);
  },
);

final facturaDetalleProvider = FutureProvider.family<Factura, int>(
  (ref, idFactura) {
    return ref.read(facturasDatasourceProvider).retrieve(idFactura);
  },
);
