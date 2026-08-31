import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class WeatherBackground extends StatelessWidget {
  final String mainCondition;
  final bool isDay;
  final Widget child;

  const WeatherBackground({
    super.key,
    required this.mainCondition,
    required this.isDay,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.gradientFor(mainCondition, isDay: isDay);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ),
      ),
      child: child,
    );
  }
}
