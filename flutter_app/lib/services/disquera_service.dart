import '../models/disquera.dart';
import 'api_service.dart';

class DisqueraService {
  final ApiService _apiService = ApiService();

  Future<List<Disquera>> getDisqueras() async {
    final response = await _apiService.get('disqueras/');
    if (response is List) {
      return response.map((json) => Disquera.fromJson(json)).toList();
    } else if (response is Map && response.containsKey('results')) {
      return (response['results'] as List).map((json) => Disquera.fromJson(json)).toList();
    }
    return [];
  }

  Future<Disquera> getDisquera(int id) async {
    final response = await _apiService.get('disqueras/$id/');
    return Disquera.fromJson(response);
  }

  Future<Disquera> createDisquera(Disquera disquera) async {
    final response = await _apiService.post('disqueras/', disquera.toJson());
    return Disquera.fromJson(response);
  }

  Future<Disquera> updateDisquera(int id, Disquera disquera) async {
    final response = await _apiService.put('disqueras/$id/', disquera.toJson());
    return Disquera.fromJson(response);
  }

  Future<void> deleteDisquera(int id) async {
    await _apiService.delete('disqueras/$id/');
  }
}
