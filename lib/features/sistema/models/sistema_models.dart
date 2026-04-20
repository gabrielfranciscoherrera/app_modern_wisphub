class PlanInternet {
  final int id;
  final String nombre;
  final String? velocidadBajada;
  final String? velocidadSubida;
  final double? precio;

  const PlanInternet({
    required this.id,
    required this.nombre,
    this.velocidadBajada,
    this.velocidadSubida,
    this.precio,
  });

  factory PlanInternet.fromJson(Map<String, dynamic> json) {
    return PlanInternet(
      id: json['id'] as int,
      nombre: json['nombre'] ?? '',
      velocidadBajada: json['velocidad_bajada']?.toString(),
      velocidadSubida: json['velocidad_subida']?.toString(),
      precio: (json['precio'] as num?)?.toDouble(),
    );
  }
}

class Zona {
  final int id;
  final String nombre;

  const Zona({required this.id, required this.nombre});

  factory Zona.fromJson(Map<String, dynamic> json) {
    return Zona(id: json['id'] as int, nombre: json['nombre'] ?? '');
  }
}

class Router {
  final int id;
  final String nombre;
  final String? ip;
  final String? modelo;

  const Router({required this.id, required this.nombre, this.ip, this.modelo});

  factory Router.fromJson(Map<String, dynamic> json) {
    return Router(
      id: json['id'] as int,
      nombre: json['nombre'] ?? '',
      ip: json['ip'],
      modelo: json['modelo']?['nombre'],
    );
  }
}
