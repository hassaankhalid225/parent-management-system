import 'package:flutter/material.dart';

/// Application color constants for light and dark themes
class AppColors {
  AppColors._();

  // Light Mode Colors
  static const Color lightPrimary = Color(0xFF6C63FF);
  static const Color lightSecondary = Color(0xFFFF6584);
  static const Color lightAccent = Color(0xFF4ECDC4);
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF7F7F7);
  static const Color lightTextPrimary = Color(0xFF2D3436);
  static const Color lightTextSecondary = Color(0xFF636E72);
  static const Color lightSuccess = Color(0xFF00B894);
  static const Color lightWarning = Color(0xFFFDCB6E);
  static const Color lightError = Color(0xFFD63031);
  static const Color lightInfo = Color(0xFF0984E3);

  // Dark Mode Colors
  static const Color darkPrimary = Color(0xFF8B83FF);
  static const Color darkSecondary = Color(0xFFFF7A93);
  static const Color darkAccent = Color(0xFF6EDFD6);
  static const Color darkBackground = Color(0xFF1A1A2E);
  static const Color darkSurface = Color(0xFF16213E);
  static const Color darkTextPrimary = Color(0xFFEAEAEA);
  static const Color darkTextSecondary = Color(0xFFB4B4B4);
  static const Color darkSuccess = Color(0xFF00D2A0);
  static const Color darkWarning = Color(0xFFFFD93D);
  static const Color darkError = Color(0xFFFF6B6B);
  static const Color darkInfo = Color(0xFF4A90E2);

  // Common Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;

  // Activity Type Colors
  static const Color mealColor = Color(0xFFFF6B6B);
  static const Color playColor = Color(0xFF4ECDC4);
  static const Color studyColor = Color(0xFF6C63FF);
  static const Color napColor = Color(0xFF9B59B6);
  static const Color specialActivityColor = Color(0xFFFF9F43);

  // Status Colors
  static const Color paidStatus = Color(0xFF00B894);
  static const Color pendingStatus = Color(0xFFFDCB6E);
  static const Color overdueStatus = Color(0xFFD63031);

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF6C63FF),
    Color(0xFF8B83FF),
  ];

  static const List<Color> secondaryGradient = [
    Color(0xFFFF6584),
    Color(0xFFFF7A93),
  ];

  static const List<Color> accentGradient = [
    Color(0xFF4ECDC4),
    Color(0xFF6EDFD6),
  ];

  static const List<Color> successGradient = [
    Color(0xFF00B894),
    Color(0xFF00D2A0),
  ];

  static const List<Color> warningGradient = [
    Color(0xFFFDCB6E),
    Color(0xFFFFD93D),
  ];

  static const List<Color> errorGradient = [
    Color(0xFFD63031),
    Color(0xFFFF6B6B),
  ];

  static const List<Color> infoGradient = [
    Color(0xFF0984E3),
    Color(0xFF4A90E2),
  ];
}
