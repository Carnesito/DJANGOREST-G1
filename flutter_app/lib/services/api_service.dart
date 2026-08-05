import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class ApiService {
  static const int timeoutSeconds = 15; // Heurística 1 y 7: No congelar app si no hay respuesta

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<dynamic> get(String endpoint) async {
    final headers = await _getHeaders();
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}$endpoint'),
        headers: headers,
      ).timeout(const Duration(seconds: timeoutSeconds));
      return _handleResponse(response);
    } catch (e) {
      // Heurística 2 y 9: Lenguaje del mundo real, sin stack traces
      throw Exception('Error de conexión: Verifica tu internet o intenta más tarde.');
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final headers = await _getHeaders();
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: timeoutSeconds));
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error de conexión: Verifica tu internet o intenta más tarde.');
    }
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final headers = await _getHeaders();
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: timeoutSeconds));
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error de conexión: Verifica tu internet o intenta más tarde.');
    }
  }

  Future<dynamic> delete(String endpoint) async {
    final headers = await _getHeaders();
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}$endpoint'),
        headers: headers,
      ).timeout(const Duration(seconds: timeoutSeconds));
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error de conexión: Verifica tu internet o intenta más tarde.');
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      String errorMessage = 'Ocurrió un error en el servidor.';
      try {
        // Intentar parsear el error del backend para dar un mensaje más útil sin ser demasiado técnico
        final errorData = jsonDecode(utf8.decode(response.bodyBytes));
        if (errorData is Map) {
          if (errorData.containsKey('detail')) {
            errorMessage = errorData['detail'];
          } else {
            // Unimos los primeros mensajes de error de validación (ej. {"nombre": ["Este campo es obligatorio."]})
            errorMessage = errorData.values.map((v) => v is List ? v.first : v.toString()).join('\n');
          }
        }
      } catch (_) {}
      
      // Heurística 9: Ayudar a reconocer errores con mensajes amigables
      throw Exception(errorMessage);
    }
  }
}
