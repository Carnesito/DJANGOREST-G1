import '../models/usuario.dart';
import 'api_service.dart';

class UsuarioService {
  final ApiService _apiService = ApiService();

  Future<List<Usuario>> getUsuarios() async {
    final response = await _apiService.get('users/');
    if (response is List) {
      return response.map((json) => Usuario.fromJson(json)).toList();
    } else if (response is Map && response.containsKey('results')) {
      return (response['results'] as List).map((json) => Usuario.fromJson(json)).toList();
    }
    return [];
  }

  Future<Usuario> getUsuario(int id) async {
    final response = await _apiService.get('users/$id/');
    return Usuario.fromJson(response);
  }

  Future<Usuario> createUsuario(Usuario usuario) async {
    final response = await _apiService.post('users/', usuario.toJson());
    return Usuario.fromJson(response);
  }

  Future<Usuario> updateUsuario(int id, Usuario usuario) async {
    final response = await _apiService.put('users/$id/', usuario.toJson());
    return Usuario.fromJson(response);
  }

  Future<void> deleteUsuario(int id) async {
    await _apiService.delete('users/$id/');
  }
}
