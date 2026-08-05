import '../models/genero.dart';
import 'api_service.dart';

class GeneroService {
  final ApiService _apiService = ApiService();

  Future<List<Genero>> getGeneros() async {
    final response = await _apiService.get('generos/');
    if (response is List) {
      return response.map((json) => Genero.fromJson(json)).toList();
    } else if (response is Map && response.containsKey('results')) {
      return (response['results'] as List).map((json) => Genero.fromJson(json)).toList();
    }
    return [];
  }

  Future<Genero> getGenero(int id) async {
    final response = await _apiService.get('generos/$id/');
    return Genero.fromJson(response);
  }

  Future<Genero> createGenero(Genero genero) async {
    final response = await _apiService.post('generos/', genero.toJson());
    return Genero.fromJson(response);
  }

  Future<Genero> updateGenero(int id, Genero genero) async {
    final response = await _apiService.put('generos/$id/', genero.toJson());
    return Genero.fromJson(response);
  }

  Future<void> deleteGenero(int id) async {
    await _apiService.delete('generos/$id/');
  }
}
