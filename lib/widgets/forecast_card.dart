import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/forecast_model.dart';
import '../utils/app_colors.dart';
import '../utils/weather_icons.dart';

class DailyForecastList extends StatelessWidget {
  final List<DailyForecast> daily;

  const DailyForecastList({super.key, required this.daily});

  @override
  Widget build(BuildContext context) {
    // The /forecast endpoint gives ~5 full days of data.
    final days = daily.take(5).toList();

    // Determine the overall min/max across the week so each bar is scaled consistently.
    final overallMin = days.map((d) => d.tempMin).reduce((a, b) => a < b ? a : b);
    final overallMax = days.map((d) => d.tempMax).reduce((a, b) => a > b ? a : b);
    final range = (overallMax - overallMin).clamp(1, double.infinity);

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '5-DAY FORECAST',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ...List.generate(days.length, (index) {
                final d = days[index];
                final isToday = index == 0;

                final leftFraction = (d.tempMin - overallMin) / range;
                final widthFraction = (d.tempMax - d.tempMin) / range;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 44,
                        child: Text(
                          isToday ? 'Today' : DateFormat('EEE').format(d.date),
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 34,
                        child: Image.network(
                          WeatherIcons.networkIconUrl(d.icon),
                          width: 28,
                          height: 28,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(WeatherIcons.iconFor(d.icon), color: Colors.white, size: 22),
                        ),
                      ),
                      SizedBox(
                        width: 34,
                        child: Text(
                          '${d.tempMin.round()}°',
                          textAlign: TextAlign.right,
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final trackWidth = constraints.maxWidth;
                            final barLeft = leftFraction.clamp(0.0, 1.0) * trackWidth;
                            final barWidth =
                                (widthFraction.clamp(0.06, 1.0)) * trackWidth;
                            final clampedWidth =
                                (barLeft + barWidth > trackWidth) ? trackWidth - barLeft : barWidth;

                            return SizedBox(
                              height: 4,
                              child: Stack(
                                children: [
                                  Container(
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  Positioned(
                                    left: barLeft,
                                    width: clampedWidth.clamp(4.0, trackWidth),
                                    child: Container(
                                      height: 4,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [Color(0xFF8FC5F4), Color(0xFFFFC97A)],
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 34,
                        child: Text(
                          '${d.tempMax.round()}°',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
