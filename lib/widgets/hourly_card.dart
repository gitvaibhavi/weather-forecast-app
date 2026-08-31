import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/forecast_model.dart';
import '../utils/app_colors.dart';
import '../utils/weather_icons.dart';

class HourlyForecastStrip extends StatelessWidget {
  final List<HourlyForecast> hourly;

  const HourlyForecastStrip({super.key, required this.hourly});

  @override
  Widget build(BuildContext context) {
    // Show roughly the next 24 hours (8 slots of 3 hours each).
    final slots = hourly.take(8).toList();

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16, bottom: 10),
                child: Text(
                  'HOURLY FORECAST',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 110,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: slots.length,
                  itemBuilder: (context, index) {
                    final h = slots[index];
                    return Container(
                      width: 64,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            index == 0 ? 'Now' : DateFormat('HH:mm').format(h.time),
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                          ),
                          const SizedBox(height: 8),
                          Image.network(
                            WeatherIcons.networkIconUrl(h.icon),
                            width: 34,
                            height: 34,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(WeatherIcons.iconFor(h.icon), color: Colors.white, size: 28),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${h.temperature.round()}°',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
