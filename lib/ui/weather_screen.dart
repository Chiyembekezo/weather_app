import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/weather/weather_bloc.dart';
import '../repositories/weather_repository.dart';

class WeatherScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: BlocProvider(
        create: (context) => WeatherBloc(weatherRepository: RepositoryProvider.of<WeatherRepository>(context)),
        child: WeatherView(),
      ),
    );
  }
}

class WeatherView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state is WeatherInitialState) {
          context.read<WeatherBloc>().add(FetchWeather('Lusaka'));
          return Center(child: CircularProgressIndicator());
        } else if (state is WeatherLoadingState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is WeatherLoadedState) {
          return ListView.builder(
            itemCount: state.weatherData.days.length,
            itemBuilder: (context, index) {
              final hour = state.weatherData.days[index];
              return ListTile(
                title: Text(hour.datetime),
                subtitle: Text('${hour.temp}°'),
              );
            },
          );
        } else if (state is WeatherErrorState) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return Center(child: Text('Something went wrong!'));
        }
      },
    );
  }
}
