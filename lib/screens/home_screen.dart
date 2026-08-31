import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../services/weather_api.dart';
import '../widgets/weather_card.dart';
import '../widgets/hourly_card.dart';
import '../widgets/forecast_card.dart';
import '../widgets/details_grid.dart';
import '../widgets/weather_background.dart';
import '../widgets/loading_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum _LoadState { loading, loaded, error }

class _HomeScreenState extends State<HomeScreen> {
  final WeatherAPI _api = WeatherAPI();

  Weather? _weather;
  List<HourlyForecast> _hourly = [];
  List<DailyForecast> _daily = [];

  _LoadState _state = _LoadState.loading;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    setState(() {
      _state = _LoadState.loading;
    });

    try {
      final position = await _determinePosition();

      final results = await Future.wait([
        _api.fetchWeather(position.latitude, position.longitude),
        _api.fetchForecast(position.latitude, position.longitude),
      ]);

      final weather = results[0] as Weather;
      final forecast = results[1] as ({
        List<HourlyForecast> hourly,
        List<DailyForecast> daily
      });

      setState(() {
        _weather = weather;
        _hourly = forecast.hourly;
        _daily = forecast.daily;
        _state = _LoadState.loaded;
      });
    } on WeatherApiException catch (e) {
      setState(() {
        _errorMessage = e.message;
        _state = _LoadState.error;
      });
    } on _LocationException catch (e) {
      setState(() {
        _errorMessage = e.message;
        _state = _LoadState.error;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Something went wrong. Please try again.';
        _state = _LoadState.error;
      });
    }
  }

  Future<Position> _determinePosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw _LocationException(
          'Location services are disabled. Please enable GPS.');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw _LocationException(
            'Location permission denied. Enable it to see local weather.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw _LocationException(
        'Location permission permanently denied. Enable it from app settings.',
      );
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
    );
  }

  bool get _isDay {
    if (_weather == null) return true;
    final now = _weather!.timestamp;
    return now.isAfter(_weather!.sunrise) && now.isBefore(_weather!.sunset);
  }

  @override
  Widget build(BuildContext context) {
    final mainCondition = _weather?.mainCondition ?? 'Clear';

    return Scaffold(
      body: WeatherBackground(
        mainCondition: mainCondition,
        isDay: _isDay,
        child: SafeArea(
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_state) {
      case _LoadState.loading:
        return const LoadingWidget();
      case _LoadState.error:
        return ErrorStateWidget(message: _errorMessage, onRetry: _loadWeather);
      case _LoadState.loaded:
        return RefreshIndicator(
          onRefresh: _loadWeather,
          color: Colors.white,
          backgroundColor: Colors.black.withOpacity(0.3),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on_rounded,
                      color: Colors.white70, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    _weather!.city,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              WeatherCard(weather: _weather!),
              const SizedBox(height: 16),
              HourlyForecastStrip(hourly: _hourly),
              const SizedBox(height: 16),
              DailyForecastList(daily: _daily),
              const SizedBox(height: 16),
              DetailsGrid(weather: _weather!),
            ],
          ),
        );
    }
  }
}

class _LocationException implements Exception {
  final String message;
  _LocationException(this.message);
}
