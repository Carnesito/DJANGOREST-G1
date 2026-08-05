import '../models/album.dart';
import 'api_service.dart';

class AlbumService {
  final ApiService _apiService = ApiService();

  Future<List<Album>> getAlbums() async {
    final response = await _apiService.get('albumes/');
    if (response is List) {
      return response.map((json) => Album.fromJson(json)).toList();
    } else if (response is Map && response.containsKey('results')) {
      return (response['results'] as List).map((json) => Album.fromJson(json)).toList();
    }
    return [];
  }

  Future<Album> getAlbum(int id) async {
    final response = await _apiService.get('albumes/$id/');
    return Album.fromJson(response);
  }

  Future<Album> createAlbum(Album album) async {
    final response = await _apiService.post('albumes/', album.toJson());
    return Album.fromJson(response);
  }

  Future<Album> updateAlbum(int id, Album album) async {
    final response = await _apiService.put('albumes/$id/', album.toJson());
    return Album.fromJson(response);
  }

  Future<void> deleteAlbum(int id) async {
    await _apiService.delete('albumes/$id/');
  }
}
