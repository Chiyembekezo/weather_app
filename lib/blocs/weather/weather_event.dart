part of 'weather_bloc.dart';

abstract class WeatherEvent extends Equatable {}

class FetchWeather extends WeatherEvent {
  final String location;

  FetchWeather(this.location);

  @override
  // TODO: implement props
  List<Object?> get props => [location];
}