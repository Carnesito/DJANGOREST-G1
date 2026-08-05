import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class AuthService {
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}token/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', data['access']);
        if (data.containsKey('refresh')) {
           await prefs.setString('refresh_token', data['refresh']);
        }
        return data;
      } else if (response.statusCode == 401) {
        throw Exception('Usuario o contraseña incorrectos.'); // Heurística 2 y 9
      } else {
        throw Exception('Error al iniciar sesión. Inténtalo de nuevo.');
      }
    } catch (e) {
      if (e.toString().contains('Usuario o contraseña incorrectos')) {
        rethrow;
      }
      throw Exception('Error de conexión. Verifica tu internet o intenta más tarde.');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }

  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('access_token');
  }
}
