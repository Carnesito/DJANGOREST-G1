import '../models/cancion.dart';
import 'api_service.dart';

class CancionService {
  final ApiService _apiService = ApiService();

  Future<List<Cancion>> getCanciones() async {
    final response = await _apiService.get('canciones/');
    if (response is List) {
      return response.map((json) => Cancion.fromJson(json)).toList();
    } else if (response is Map && response.containsKey('results')) {
      return (response['results'] as List).map((json) => Cancion.fromJson(json)).toList();
    }
    return [];
  }

  Future<Cancion> getCancion(int id) async {
    final response = await _apiService.get('canciones/$id/');
    return Cancion.fromJson(response);
  }

  Future<Cancion> createCancion(Cancion cancion) async {
    final response = await _apiService.post('canciones/', cancion.toJson());
    return Cancion.fromJson(response);
  }

  Future<Cancion> updateCancion(int id, Cancion cancion) async {
    final response = await _apiService.put('canciones/$id/', cancion.toJson());
    return Cancion.fromJson(response);
  }

  Future<void> deleteCancion(int id) async {
    await _apiService.delete('canciones/$id/');
  }
}
