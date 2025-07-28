// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color secondaryColor = Color(0xFF1E3A8A);
  static const Color accentColor = Color(0xFFFF9800);
  static const Color greenColor = Color(0xFF10B981);
  static const Color backgroundColor = Color(0xFFF5F5F5);

  // Colores para las tarjetas de verificación
  static const Color areaCardColor = Color.fromARGB(255, 250, 190, 190);
  static const Color locationCardColor = Color(0xFFD6EAFF);
  static const Color responsibleCardColor = Color.fromARGB(255, 208, 246, 180);
  static const Color custodianCardColor = Color.fromARGB(255, 245, 210, 184);
  static const Color customCardColor = Color(0xFFE0E0E0);

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
