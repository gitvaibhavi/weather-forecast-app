import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/weather_model.dart';
import '../utils/app_colors.dart';
import '../utils/weather_icons.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;

  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            children: [
              Text(
                DateFormat('EEEE, d MMMM').format(weather.timestamp),
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 12),
              Image.network(
                WeatherIcons.networkIconUrl(weather.icon),
                width: 110,
                height: 110,
                errorBuilder: (context, error, stackTrace) => Icon(
                  WeatherIcons.iconFor(weather.icon),
                  size: 90,
                  color: Colors.white,
                ),
              ),
              Text(
                '${weather.temperature.round()}°',
                style: const TextStyle(
                  fontSize: 72,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w200,
                  height: 1.0,
                ),
              ),
              Text(
                weather.description.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Feels like ${weather.feelsLike.round()}°  ·  H:${weather.tempMax.round()}°  L:${weather.tempMin.round()}°',
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
