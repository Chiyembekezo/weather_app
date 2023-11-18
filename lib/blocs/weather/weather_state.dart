part of 'weather_bloc.dart';


abstract class WeatherState {}

class WeatherInitialState extends WeatherState {}

class WeatherLoadingState extends WeatherState {}

class WeatherLoadedState extends WeatherState {
  final WeatherData weatherData;

  WeatherLoadedState(this.weatherData);
}

class WeatherErrorState extends WeatherState {
  final String message;

  WeatherErrorState(this.message);
}

