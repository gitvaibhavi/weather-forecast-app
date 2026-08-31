import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/weather_model.dart';
import '../models/forecast_model.dart';

class WeatherApiException implements Exception {
  final String message;
  WeatherApiException(this.message);

  @override
  String toString() => message;
}

class WeatherAPI {
  // TODO: move this to a secure location (--dart-define / env file) before
  // shipping. It is left inline here only to match your original setup.
  static const String _apiKey = '974b5c6cde14d9f9a7bcfdf1f1c76f24';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  /// Fetches current weather conditions for the given coordinates.
  Future<Weather> fetchWeather(double lat, double lon) async {
    final url = Uri.parse(
      '$_baseUrl/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric',
    );

    final response = await http.get(url).timeout(
          const Duration(seconds: 15),
          onTimeout: () => throw WeatherApiException(
            'The request timed out. Check your connection and try again.',
          ),
        );

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw WeatherApiException('Invalid API key.');
    } else if (response.statusCode == 429) {
      throw WeatherApiException('Too many requests. Try again shortly.');
    } else {
      throw WeatherApiException('Could not load current weather (${response.statusCode}).');
    }
  }

  /// Fetches the 5-day / 3-hour forecast and returns it both as raw hourly
  /// slots and aggregated into daily min/max entries.
  Future<({List<HourlyForecast> hourly, List<DailyForecast> daily})> fetchForecast(
    double lat,
    double lon,
  ) async {
    final url = Uri.parse(
      '$_baseUrl/forecast?lat=$lat&lon=$lon&appid=$_apiKey&units=metric',
    );

    final response = await http.get(url).timeout(
          const Duration(seconds: 15),
          onTimeout: () => throw WeatherApiException(
            'The request timed out. Check your connection and try again.',
          ),
        );

    if (response.statusCode != 200) {
      throw WeatherApiException('Could not load forecast (${response.statusCode}).');
    }

    final body = jsonDecode(response.body);
    final int tzOffset = body['city']?['timezone'] ?? 0;
    final List list = body['list'] ?? [];

    final hourly = list
        .map((e) => HourlyForecast.fromJson(e as Map<String, dynamic>, tzOffset))
        .toList()
        .cast<HourlyForecast>();

    final daily = DailyForecast.fromHourlyList(hourly);

    return (hourly: hourly, daily: daily);
  }
}
