import '../models/artista.dart';
import 'api_service.dart';

class ArtistaService {
  final ApiService _apiService = ApiService();

  Future<List<Artista>> getArtistas() async {
    final response = await _apiService.get('artistas/');
    if (response is List) {
      return response.map((json) => Artista.fromJson(json)).toList();
    } else if (response is Map && response.containsKey('results')) {
      return (response['results'] as List).map((json) => Artista.fromJson(json)).toList();
    }
    return [];
  }

  Future<Artista> getArtista(int id) async {
    final response = await _apiService.get('artistas/$id/');
    return Artista.fromJson(response);
  }

  Future<Artista> createArtista(Artista artista) async {
    final response = await _apiService.post('artistas/', artista.toJson());
    return Artista.fromJson(response);
  }

  Future<Artista> updateArtista(int id, Artista artista) async {
    final response = await _apiService.put('artistas/$id/', artista.toJson());
    return Artista.fromJson(response);
  }

  Future<void> deleteArtista(int id) async {
    await _apiService.delete('artistas/$id/');
  }
}
