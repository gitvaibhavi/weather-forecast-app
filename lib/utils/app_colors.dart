import 'package:flutter/material.dart';

/// Returns a gradient that reflects the current weather condition and
/// roughly whether it's day or night, similar to native weather apps.
class AppColors {
  static List<Color> gradientFor(String mainCondition, {required bool isDay}) {
    final condition = mainCondition.toLowerCase();

    if (!isDay) {
      return const [Color(0xFF0F1B3C), Color(0xFF1B2A4A), Color(0xFF0B1229)];
    }

    switch (condition) {
      case 'clear':
        return const [Color(0xFF2A72D5), Color(0xFF5EA6E8), Color(0xFF8FC5F4)];
      case 'clouds':
        return const [Color(0xFF5C6B7A), Color(0xFF7A8B9C), Color(0xFF9AAAB8)];
      case 'rain':
      case 'drizzle':
        return const [Color(0xFF34495E), Color(0xFF4A6178), Color(0xFF64798D)];
      case 'thunderstorm':
        return const [Color(0xFF1C2331), Color(0xFF2C3548), Color(0xFF3E4A63)];
      case 'snow':
        return const [Color(0xFF6E8CA0), Color(0xFF9CB8C7), Color(0xFFC9DCE6)];
      case 'mist':
      case 'fog':
      case 'haze':
        return const [Color(0xFF5B6B73), Color(0xFF7D8E96), Color(0xFFA3B2B9)];
      default:
        return const [Color(0xFF2A72D5), Color(0xFF5EA6E8), Color(0xFF8FC5F4)];
    }
  }

  static const Color cardBackground = Color(0x14FFFFFF);
  static const Color cardBorder = Color(0x33FFFFFF);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
}
