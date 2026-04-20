class Ticket {
  final int idTicket;
  final String asunto;
  final String estado;
  final String? clienteNombre;
  final String fechaCreacion;
  final String? descripcion;

  const Ticket({
    required this.idTicket,
    required this.asunto,
    required this.estado,
    this.clienteNombre,
    required this.fechaCreacion,
    this.descripcion,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      idTicket: json['id_ticket'] as int,
      asunto: json['asunto'] ?? '',
      estado: json['estado'] ?? '',
      clienteNombre: json['cliente']?['nombre_completo'] ?? json['cliente']?['nombre'],
      fechaCreacion: json['fecha_creacion'] ?? '',
      descripcion: json['descripcion'],
    );
  }
}
