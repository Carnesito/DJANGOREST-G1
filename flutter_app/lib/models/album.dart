class Album {
  final int id;
  final String titulo;
  final String fechaLanzamiento;
  final String? portadaUrl;
  final int disquera;
  final bool estado;

  Album({
    required this.id,
    required this.titulo,
    required this.fechaLanzamiento,
    this.portadaUrl,
    required this.disquera,
    required this.estado,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'] ?? 0,
      titulo: json['titulo'] ?? '',
      fechaLanzamiento: json['fecha_lanzamiento'] ?? '',
      portadaUrl: json['portada_url'],
      disquera: json['disquera'] ?? 0,
      estado: json['estado'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id > 0) 'id': id,
      'titulo': titulo,
      'fecha_lanzamiento': fechaLanzamiento,
      'portada_url': portadaUrl,
      'disquera': disquera,
      'estado': estado,
    };
  }
}
