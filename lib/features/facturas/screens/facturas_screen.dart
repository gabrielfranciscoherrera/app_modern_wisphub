import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/factura_model.dart';
import '../providers/facturas_provider.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/error_display.dart';

class FacturasScreen extends ConsumerStatefulWidget {
  const FacturasScreen({super.key});

  @override
  ConsumerState<FacturasScreen> createState() => _FacturasScreenState();
}

class _FacturasScreenState extends ConsumerState<FacturasScreen> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(facturasListProvider(_page));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Facturas'),
        actions: [
          if (_page > 0)
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => setState(() => _page--),
            ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: () => setState(() => _page++),
          ),
        ],
      ),
      body: async.when(
        loading: () => const LoadingWidget(),
        error: (e, _) => ErrorDisplay(message: e.toString()),
        data: (facturas) => _FacturasList(facturas: facturas),
      ),
    );
  }
}

class _FacturasList extends StatelessWidget {
  final List<Factura> facturas;
  const _FacturasList({required this.facturas});

  @override
  Widget build(BuildContext context) {
    if (facturas.isEmpty) {
      return const Center(child: Text('No hay facturas en este período.'));
    }
    return ListView.separated(
      itemCount: facturas.length,
      separatorBuilder: (_, i) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final f = facturas[i];
        final pagada = f.estado == 'pagada';
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: pagada ? Colors.green.shade100 : Colors.orange.shade100,
            child: Icon(
              Icons.receipt_long,
              color: pagada ? Colors.green : Colors.orange,
            ),
          ),
          title: Text(f.clienteNombre ?? 'Factura #${f.idFactura}'),
          subtitle: Text('Emitida: ${f.fechaEmision}  •  Vence: ${f.fechaVencimiento}'),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('\$${f.monto.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Chip(
                label: Text(f.estado,
                    style: TextStyle(
                      fontSize: 10,
                      color: pagada ? Colors.green.shade800 : Colors.orange.shade800,
                    )),
                backgroundColor: pagada ? Colors.green.shade50 : Colors.orange.shade50,
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        );
      },
    );
  }
}
