import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ticket_model.dart';
import '../providers/tickets_provider.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/error_display.dart';

class TicketsScreen extends ConsumerStatefulWidget {
  const TicketsScreen({super.key});

  @override
  ConsumerState<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends ConsumerState<TicketsScreen> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(ticketsListProvider(_page));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tickets de Soporte'),
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
        data: (tickets) => _TicketsList(tickets: tickets),
      ),
    );
  }
}

class _TicketsList extends StatelessWidget {
  final List<Ticket> tickets;
  const _TicketsList({required this.tickets});

  @override
  Widget build(BuildContext context) {
    if (tickets.isEmpty) {
      return const Center(child: Text('No hay tickets registrados.'));
    }
    return ListView.separated(
      itemCount: tickets.length,
      separatorBuilder: (_, a) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final t = tickets[i];
        final abierto = t.estado == 'abierto';
        return ListTile(
          leading: CircleAvatar(
            backgroundColor:
                abierto ? Colors.blue.shade100 : Colors.grey.shade200,
            child: Icon(
              Icons.support_agent,
              color: abierto ? Colors.blue : Colors.grey,
            ),
          ),
          title: Text(t.asunto),
          subtitle: Text(
              '${t.clienteNombre ?? 'Sin cliente'}  •  ${t.fechaCreacion}'),
          trailing: Chip(
            label: Text(
              t.estado,
              style: TextStyle(
                fontSize: 10,
                color: abierto ? Colors.blue.shade800 : Colors.grey.shade700,
              ),
            ),
            backgroundColor:
                abierto ? Colors.blue.shade50 : Colors.grey.shade100,
            padding: EdgeInsets.zero,
          ),
          onTap: () => _showDetalle(context, t),
        );
      },
    );
  }

  void _showDetalle(BuildContext context, Ticket t) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ticket #${t.idTicket}',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Asunto: ${t.asunto}'),
            Text('Estado: ${t.estado}'),
            Text('Cliente: ${t.clienteNombre ?? '-'}'),
            Text('Fecha: ${t.fechaCreacion}'),
            if (t.descripcion != null) ...[
              const SizedBox(height: 8),
              Text(t.descripcion!),
            ],
          ],
        ),
      ),
    );
  }
}
