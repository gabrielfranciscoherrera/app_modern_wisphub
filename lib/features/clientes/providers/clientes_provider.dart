import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../data/clientes_datasource.dart';
import '../models/cliente_model.dart';

final clientesDatasourceProvider = Provider<ClientesDatasource>((ref) {
  return ClientesDatasource(ref.read(apiClientProvider));
});

final clientesListProvider = FutureProvider.family<List<Cliente>, int>(
  (ref, page) {
    final ds = ref.read(clientesDatasourceProvider);
    return ds.list(limit: 50, offset: page * 50);
  },
);

final clienteDetalleProvider = FutureProvider.family<Cliente, int>(
  (ref, idServicio) {
    return ref.read(clientesDatasourceProvider).retrieve(idServicio);
  },
);

final clienteSaldoProvider = FutureProvider.family<SaldoCliente, int>(
  (ref, idServicio) {
    return ref.read(clientesDatasourceProvider).saldo(idServicio);
  },
);
