class Cancion {
  final int id;
  final String titulo;
  final int duracionSegundos;
  final String precio;
  final int album;
  final int artista;
  final bool estado;

  Cancion({
    required this.id,
    required this.titulo,
    required this.duracionSegundos,
    required this.precio,
    required this.album,
    required this.artista,
    required this.estado,
  });

  factory Cancion.fromJson(Map<String, dynamic> json) {
    return Cancion(
      id: json['id'] ?? 0,
      titulo: json['titulo'] ?? '',
      duracionSegundos: json['duracion_segundos'] ?? 0,
      precio: json['precio']?.toString() ?? '0.00',
      album: json['album'] ?? 0,
      artista: json['artista'] ?? 0,
      estado: json['estado'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id > 0) 'id': id,
      'titulo': titulo,
      'duracion_segundos': duracionSegundos,
      'precio': precio,
      'album': album,
      'artista': artista,
      'estado': estado,
    };
  }
}
