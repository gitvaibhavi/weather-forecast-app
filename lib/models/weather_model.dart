class Weather {
  final String city;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final int pressure;
  final double windSpeed;
  final int windDeg;
  final String description;
  final String icon;
  final String mainCondition;
  final DateTime sunrise;
  final DateTime sunset;
  final DateTime timestamp;
  final int timezoneOffset; // seconds from UTC

  Weather({
    required this.city,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.windDeg,
    required this.description,
    required this.icon,
    required this.mainCondition,
    required this.sunrise,
    required this.sunset,
    required this.timestamp,
    required this.timezoneOffset,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final int tzOffset = (json['timezone'] as num?)?.toInt() ?? 0;

    DateTime toLocalStationTime(int unixSeconds) {
      return DateTime.fromMillisecondsSinceEpoch(
        (unixSeconds + tzOffset) * 1000,
        isUtc: true,
      );
    }

    return Weather(
      city: json['name'] ?? 'Unknown',
      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      tempMin: (json['main']['temp_min'] as num).toDouble(),
      tempMax: (json['main']['temp_max'] as num).toDouble(),
      humidity: (json['main']['humidity'] as num?)?.toInt() ?? 0,
      pressure: (json['main']['pressure'] as num?)?.toInt() ?? 0,
      windSpeed: (json['wind']?['speed'] as num?)?.toDouble() ?? 0.0,
      windDeg: (json['wind']?['deg'] as num?)?.toInt() ?? 0,
      description: json['weather'][0]['description'] ?? '',
      icon: json['weather'][0]['icon'] ?? '01d',
      mainCondition: json['weather'][0]['main'] ?? '',
      sunrise: toLocalStationTime(
        (json['sys']['sunrise'] as num).toInt(),
      ),
      sunset: toLocalStationTime(
        (json['sys']['sunset'] as num).toInt(),
      ),
      timestamp: toLocalStationTime(
        (json['dt'] as num).toInt(),
      ),
      timezoneOffset: tzOffset,
    );
  }
}
