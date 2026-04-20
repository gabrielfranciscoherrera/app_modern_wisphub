import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../data/tickets_datasource.dart';
import '../models/ticket_model.dart';

final ticketsDatasourceProvider = Provider<TicketsDatasource>((ref) {
  return TicketsDatasource(ref.read(apiClientProvider));
});

final ticketsListProvider = FutureProvider.family<List<Ticket>, int>(
  (ref, page) {
    return ref
        .read(ticketsDatasourceProvider)
        .list(limit: 50, offset: page * 50);
  },
);

final ticketDetalleProvider = FutureProvider.family<Ticket, int>(
  (ref, idTicket) {
    return ref.read(ticketsDatasourceProvider).retrieve(idTicket);
  },
);
