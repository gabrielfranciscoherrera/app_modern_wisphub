class Factura {
  final int idFactura;
  final String? clienteNombre;
  final double monto;
  final String estado;
  final String fechaEmision;
  final String fechaVencimiento;
  final String? formaPago;

  const Factura({
    required this.idFactura,
    this.clienteNombre,
    required this.monto,
    required this.estado,
    required this.fechaEmision,
    required this.fechaVencimiento,
    this.formaPago,
  });

  factory Factura.fromJson(Map<String, dynamic> json) {
    return Factura(
      idFactura: json['id_factura'] as int,
      clienteNombre: json['cliente']?['nombre_completo'] ?? json['cliente']?['nombre'],
      monto: (json['monto'] as num?)?.toDouble() ?? 0,
      estado: json['estado'] ?? '',
      fechaEmision: json['fecha_emision'] ?? '',
      fechaVencimiento: json['fecha_vencimiento'] ?? '',
      formaPago: json['forma_pago']?['nombre'],
    );
  }
}
