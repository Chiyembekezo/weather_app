part of 'weather_bloc.dart';

abstract class WeatherEvent {}

class FetchWeather extends WeatherEvent {
  final String location;

  FetchWeather(this.location);
}