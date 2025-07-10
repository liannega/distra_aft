import 'package:flutter/material.dart';

class AppTheme {
  // Colores principales de la aplicación
  static const Color primaryColor = Color(0xFF2196F3); // Azul
  static const Color secondaryColor = Color(0xFF1E3A8A); // Azul marino
  static const Color accentColor = Color(0xFFFF9800); // Naranja
  static const Color greenColor = Color(0xFF10B981); // Verde
  static const Color backgroundColor = Color(0xFFF5F5F5); // Gris claro

  // Colores para las tarjetas de verificación
  static const Color areaCardColor = Color(0xFFFFD6D6); // Rosa claro
  static const Color locationCardColor = Color(0xFFD6EAFF); // Azul claro
  static const Color responsibleCardColor = Color(0xFFE8FFD6); // Verde claro
  static const Color custodianCardColor = Color(0xFFFFE8D6); // Naranja claro
  static const Color customCardColor = Color(0xFFE0E0E0); // Gris

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        background: backgroundColor,
        surface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: primaryColor,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: primaryColor),
      ),
      scaffoldBackgroundColor: backgroundColor,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: secondaryColor),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        hintStyle: TextStyle(color: Colors.grey[400]),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: accentColor,
        unselectedLabelColor: Colors.grey,
        indicatorColor: accentColor,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
      ),
    );
  }
}
