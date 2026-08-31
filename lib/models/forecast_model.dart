/// A single raw 3-hour forecast slot returned by the /forecast endpoint.
class HourlyForecast {
  final DateTime time;
  final double temperature;
  final String icon;
  final String description;
  final int pop; // probability of precipitation, 0-100

  HourlyForecast({
    required this.time,
    required this.temperature,
    required this.icon,
    required this.description,
    required this.pop,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json, int tzOffset) {
    final dt = DateTime.fromMillisecondsSinceEpoch(
      (json['dt'] + tzOffset) * 1000,
      isUtc: true,
    );
    return HourlyForecast(
      time: dt,
      temperature: (json['main']['temp'] as num).toDouble(),
      icon: json['weather'][0]['icon'] ?? '01d',
      description: json['weather'][0]['description'] ?? '',
      pop: (((json['pop'] as num?) ?? 0) * 100).round(),
    );
  }
}

/// A day aggregated from several 3-hour slots into min/max + a representative icon.
class DailyForecast {
  final DateTime date;
  final double tempMin;
  final double tempMax;
  final String icon;
  final String description;
  final int pop;

  DailyForecast({
    required this.date,
    required this.tempMin,
    required this.tempMax,
    required this.icon,
    required this.description,
    required this.pop,
  });

  /// Builds a list of daily forecasts by grouping raw hourly slots by
  /// calendar day, picking min/max temps and the icon closest to midday.
  static List<DailyForecast> fromHourlyList(List<HourlyForecast> hourly) {
    final Map<String, List<HourlyForecast>> grouped = {};

    for (final h in hourly) {
      final key = '${h.time.year}-${h.time.month}-${h.time.day}';
      grouped.putIfAbsent(key, () => []).add(h);
    }

    final List<DailyForecast> days = [];

    grouped.forEach((key, slots) {
      double minT = slots.first.temperature;
      double maxT = slots.first.temperature;
      for (final s in slots) {
        if (s.temperature < minT) minT = s.temperature;
        if (s.temperature > maxT) maxT = s.temperature;
      }

      // Pick the slot closest to 12:00 as the representative icon/description.
      HourlyForecast midday = slots.first;
      int bestDiff = (slots.first.time.hour - 12).abs();
      for (final s in slots) {
        final diff = (s.time.hour - 12).abs();
        if (diff < bestDiff) {
          bestDiff = diff;
          midday = s;
        }
      }

      final maxPop = slots.map((s) => s.pop).fold<int>(0, (a, b) => a > b ? a : b);

      days.add(DailyForecast(
        date: DateTime(slots.first.time.year, slots.first.time.month, slots.first.time.day),
        tempMin: minT,
        tempMax: maxT,
        icon: midday.icon,
        description: midday.description,
        pop: maxPop,
      ));
    });

    days.sort((a, b) => a.date.compareTo(b.date));
    return days;
  }
}
