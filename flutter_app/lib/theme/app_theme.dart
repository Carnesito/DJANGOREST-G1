import 'package:flutter/material.dart';

class AppTheme {
  // Colores principales extraídos de Tailwind (React)
  static const Color gray900 = Color(0xFF111827); // Fondo principal login/tarjetas
  static const Color gray800 = Color(0xFF1F2937); // Encabezados/Inputs
  static const Color gray700 = Color(0xFF374151); // Bordes y botones secundarios
  static const Color green400 = Color(0xFF4ADE80); // Acentos (textos)
  static const Color green500 = Color(0xFF22C55E); // Botones principales
  static const Color green600 = Color(0xFF16A34A); // Botones hover
  static const Color blueGray100 = Color(0xFFF1F5F9); // Fondo panel admin
  static const Color indigo400 = Color(0xFF818CF8); // Acción Editar
  static const Color red400 = Color(0xFFF87171); // Acción Eliminar
  static const Color red500 = Color(0xFFEF4444); // Errores

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: green500,
      scaffoldBackgroundColor: gray900,
      appBarTheme: const AppBarTheme(
        backgroundColor: gray800,
        elevation: 0,
        iconTheme: IconThemeData(color: green400),
        titleTextStyle: TextStyle(
          color: green400,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: green500,
        secondary: green400,
        surface: gray800,
        error: red500,
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: gray800,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: gray700),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: gray700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: green400),
        ),
        labelStyle: const TextStyle(color: green400),
        hintStyle: const TextStyle(color: Color(0xFF6B7280)), // gray-500
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: green500,
          foregroundColor: gray900,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // rounded-full
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: green400,
        ),
      ),
      cardTheme: CardThemeData(
        color: gray900,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // rounded-lg
        ),
      ),
    );
  }
}
