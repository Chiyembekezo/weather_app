part of 'weather_bloc.dart';


abstract class WeatherState extends Equatable {}

class WeatherInitialState extends WeatherState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class WeatherLoadingState extends WeatherState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class WeatherLoadedState extends WeatherState {
  final WeatherData weatherData;

  WeatherLoadedState(this.weatherData);

  @override
  // TODO: implement props
  List<Object?> get props => [weatherData];
}

class WeatherErrorState extends WeatherState {
  final String message;

  WeatherErrorState(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

