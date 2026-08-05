class Genero {
  final int id;
  final String nombre;
  final String? descripcion;
  final bool estado;

  Genero({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.estado,
  });

  factory Genero.fromJson(Map<String, dynamic> json) {
    return Genero(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'],
      estado: json['estado'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id > 0) 'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'estado': estado,
    };
  }
}
