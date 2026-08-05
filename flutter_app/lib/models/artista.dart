class Artista {
  final int id;
  final String nombreArtistico;
  final String generoPrincipal;
  final String? biografia;
  final int anioInicio;
  final bool estado;

  Artista({
    required this.id,
    required this.nombreArtistico,
    required this.generoPrincipal,
    this.biografia,
    required this.anioInicio,
    required this.estado,
  });

  factory Artista.fromJson(Map<String, dynamic> json) {
    return Artista(
      id: json['id'] ?? 0,
      nombreArtistico: json['nombre_artistico'] ?? '',
      generoPrincipal: json['genero_principal'] ?? '',
      biografia: json['biografia'],
      anioInicio: json['anio_inicio'] ?? 0,
      estado: json['estado'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id > 0) 'id': id,
      'nombre_artistico': nombreArtistico,
      'genero_principal': generoPrincipal,
      'biografia': biografia,
      'anio_inicio': anioInicio,
      'estado': estado,
    };
  }
}
