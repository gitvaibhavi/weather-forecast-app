import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/weather_model.dart';
import '../utils/app_colors.dart';

class DetailsGrid extends StatelessWidget {
  final Weather weather;

  const DetailsGrid({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final items = [
      _DetailItem(Icons.water_drop_outlined, 'Humidity', '${weather.humidity}%'),
      _DetailItem(Icons.air_rounded, 'Wind', '${weather.windSpeed.toStringAsFixed(1)} m/s'),
      _DetailItem(Icons.speed_rounded, 'Pressure', '${weather.pressure} hPa'),
      _DetailItem(Icons.thermostat_rounded, 'Feels Like', '${weather.feelsLike.round()}°C'),
      _DetailItem(Icons.wb_twilight_rounded, 'Sunrise', DateFormat('HH:mm').format(weather.sunrise)),
      _DetailItem(Icons.nightlight_round, 'Sunset', DateFormat('HH:mm').format(weather.sunset)),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (context, index) => _DetailTile(item: items[index]),
    );
  }
}

class _DetailItem {
  final IconData icon;
  final String label;
  final String value;
  _DetailItem(this.icon, this.label, this.value);
}

class _DetailTile extends StatelessWidget {
  final _DetailItem item;
  const _DetailTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, color: Colors.white70, size: 22),
              const SizedBox(height: 8),
              Text(
                item.label,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
              ),
              const SizedBox(height: 4),
              Text(
                item.value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
