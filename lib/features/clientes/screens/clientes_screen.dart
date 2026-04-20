import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cliente_model.dart';
import '../providers/clientes_provider.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/error_display.dart';

class ClientesScreen extends ConsumerStatefulWidget {
  const ClientesScreen({super.key});

  @override
  ConsumerState<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends ConsumerState<ClientesScreen> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(clientesListProvider(_page));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
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
        data: (clientes) => _ClientesList(clientes: clientes),
      ),
    );
  }
}

class _ClientesList extends StatelessWidget {
  final List<Cliente> clientes;
  const _ClientesList({required this.clientes});

  @override
  Widget build(BuildContext context) {
    if (clientes.isEmpty) {
      return const Center(child: Text('No hay clientes en esta página.'));
    }
    return ListView.separated(
      itemCount: clientes.length,
      separatorBuilder: (_, i) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final c = clientes[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: c.estado == 'activo'
                ? Colors.green.shade100
                : Colors.red.shade100,
            child: Icon(
              Icons.person,
              color: c.estado == 'activo' ? Colors.green : Colors.red,
            ),
          ),
          title: Text(c.nombre),
          subtitle: Text('${c.username}  •  ${c.planInternet ?? '-'}'),
          trailing: _EstadoChip(estado: c.estado),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ClienteDetalleScreen(idServicio: c.idServicio),
            ),
          ),
        );
      },
    );
  }
}

class _EstadoChip extends StatelessWidget {
  final String estado;
  const _EstadoChip({required this.estado});

  @override
  Widget build(BuildContext context) {
    final activo = estado == 'activo';
    return Chip(
      label: Text(
        estado,
        style: TextStyle(
          color: activo ? Colors.green.shade800 : Colors.red.shade800,
          fontSize: 11,
        ),
      ),
      backgroundColor: activo ? Colors.green.shade50 : Colors.red.shade50,
      padding: EdgeInsets.zero,
    );
  }
}

class ClienteDetalleScreen extends ConsumerWidget {
  final int idServicio;
  const ClienteDetalleScreen({super.key, required this.idServicio});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clienteAsync = ref.watch(clienteDetalleProvider(idServicio));
    final saldoAsync = ref.watch(clienteSaldoProvider(idServicio));

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de Cliente')),
      body: clienteAsync.when(
        loading: () => const LoadingWidget(),
        error: (e, _) => ErrorDisplay(message: e.toString()),
        data: (c) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoCard(cliente: c),
              const SizedBox(height: 16),
              saldoAsync.when(
                loading: () => const LoadingWidget(),
                error: (e, _) => ErrorDisplay(message: e.toString()),
                data: (s) => _SaldoCard(saldo: s),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final Cliente cliente;
  const _InfoCard({required this.cliente});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(cliente.nombre,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            _Row('Usuario', cliente.username),
            _Row('Estado', cliente.estado),
            _Row('Plan', cliente.planInternet ?? '-'),
            _Row('Zona', cliente.zona ?? '-'),
            _Row('IP', cliente.ip ?? '-'),
            _Row('Teléfono', cliente.telefono ?? '-'),
            _Row('Email', cliente.email ?? '-'),
          ],
        ),
      ),
    );
  }
}

class _SaldoCard extends StatelessWidget {
  final SaldoCliente saldo;
  const _SaldoCard({required this.saldo});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Saldo', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            _Row('Saldo a favor', '\$${saldo.saldo.toStringAsFixed(2)}'),
            _Row('Deuda pendiente', '\$${saldo.deuda.toStringAsFixed(2)}'),
            if (saldo.facturasPendientes.isNotEmpty) ...[
              const Divider(),
              Text('Facturas pendientes',
                  style: Theme.of(context).textTheme.bodySmall),
              ...saldo.facturasPendientes.map(
                (f) => _Row(
                  'Factura #${f.idFactura}',
                  '\$${f.monto.toStringAsFixed(2)} — vence ${f.fechaVencimiento}',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(label,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
