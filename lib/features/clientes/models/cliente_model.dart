class Cliente {
  final int idServicio;
  final String nombre;
  final String username;
  final String estado;
  final String? planInternet;
  final String? zona;
  final String? ip;
  final String? telefono;
  final String? email;

  const Cliente({
    required this.idServicio,
    required this.nombre,
    required this.username,
    required this.estado,
    this.planInternet,
    this.zona,
    this.ip,
    this.telefono,
    this.email,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      idServicio: json['id_servicio'] as int,
      nombre: json['nombre_completo'] ?? json['nombre'] ?? '',
      username: json['username'] ?? '',
      estado: json['estado'] ?? '',
      planInternet: json['plan_internet']?['nombre'],
      zona: json['zona']?['nombre'],
      ip: json['ip'],
      telefono: json['telefono'],
      email: json['email'],
    );
  }
}

class SaldoCliente {
  final double saldo;
  final double deuda;
  final List<FacturaPendiente> facturasPendientes;

  const SaldoCliente({
    required this.saldo,
    required this.deuda,
    required this.facturasPendientes,
  });

  factory SaldoCliente.fromJson(Map<String, dynamic> json) {
    final facturas = (json['facturas_pendientes'] as List<dynamic>? ?? [])
        .map((f) => FacturaPendiente.fromJson(f as Map<String, dynamic>))
        .toList();
    return SaldoCliente(
      saldo: (json['saldo'] as num?)?.toDouble() ?? 0,
      deuda: (json['deuda'] as num?)?.toDouble() ?? 0,
      facturasPendientes: facturas,
    );
  }
}

class FacturaPendiente {
  final int idFactura;
  final double monto;
  final String fechaVencimiento;

  const FacturaPendiente({
    required this.idFactura,
    required this.monto,
    required this.fechaVencimiento,
  });

  factory FacturaPendiente.fromJson(Map<String, dynamic> json) {
    return FacturaPendiente(
      idFactura: json['id_factura'] as int,
      monto: (json['monto'] as num?)?.toDouble() ?? 0,
      fechaVencimiento: json['fecha_vencimiento'] ?? '',
    );
  }
}
