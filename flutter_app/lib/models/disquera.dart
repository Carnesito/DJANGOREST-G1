class Disquera {
  final int id;
  final String nombre;
  final String paisOrigen;
  final int anioFundacion;
  final String emailContacto;
  final bool estado;

  Disquera({
    required this.id,
    required this.nombre,
    required this.paisOrigen,
    required this.anioFundacion,
    required this.emailContacto,
    required this.estado,
  });

  factory Disquera.fromJson(Map<String, dynamic> json) {
    return Disquera(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? '',
      paisOrigen: json['pais_origen'] ?? '',
      anioFundacion: json['anio_fundacion'] ?? 0,
      emailContacto: json['email_contacto'] ?? '',
      estado: json['estado'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id > 0) 'id': id,
      'nombre': nombre,
      'pais_origen': paisOrigen,
      'anio_fundacion': anioFundacion,
      'email_contacto': emailContacto,
      'estado': estado,
    };
  }
}
