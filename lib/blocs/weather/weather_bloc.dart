
import 'package:bloc/bloc.dart';

import '../../models/weather_data.dart';
import '../../repositories/weather_repository.dart';
import 'package:equatable/equatable.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherBloc({required this.weatherRepository}) : super(WeatherInitialState()) {
    on<FetchWeather>((event, emit) async {
      emit(WeatherLoadingState());
      try {
        final weatherData = await weatherRepository.fetchHourlyWeather(event.location);
        print('This Is The City in Bloc: ${event.location}');
        emit(WeatherLoadedState(weatherData!));
      } catch (error) {
        emit(WeatherErrorState(error.toString()));
      }
    });
  }
}
