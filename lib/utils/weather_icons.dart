import 'package:flutter/material.dart';

/// Maps OpenWeatherMap icon codes to Material icons so the UI still shows
/// something sensible if the network icon image fails to load.
class WeatherIcons {
  static IconData iconFor(String owmIcon) {
    final code = owmIcon.length >= 2 ? owmIcon.substring(0, 2) : '01';
    final isNight = owmIcon.endsWith('n');

    switch (code) {
      case '01':
        return isNight ? Icons.nightlight_round : Icons.wb_sunny_rounded;
      case '02':
        return isNight ? Icons.nights_stay_rounded : Icons.wb_cloudy_rounded;
      case '03':
      case '04':
        return Icons.cloud_rounded;
      case '09':
        return Icons.grain_rounded;
      case '10':
        return Icons.water_drop_rounded;
      case '11':
        return Icons.thunderstorm_rounded;
      case '13':
        return Icons.ac_unit_rounded;
      case '50':
        return Icons.foggy;
      default:
        return Icons.wb_sunny_rounded;
    }
  }

  static String networkIconUrl(String owmIcon) =>
      'https://openweathermap.org/img/wn/$owmIcon@2x.png';
}
