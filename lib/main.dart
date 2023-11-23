import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/blocs/weather/weather_bloc.dart';
import 'package:weather_app/repositories/weather_repository.dart';
import 'package:weather_app/ui/weather_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final WeatherRepository weatherRepository = WeatherRepository(httpClient: http.Client());

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<WeatherRepository>.value(
      value: weatherRepository,
      child: BlocProvider<WeatherBloc>(
        create: (_) => WeatherBloc(weatherRepository: weatherRepository),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Weather App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const WeatherScreen(),
        ),
      ),
    );
  }
}
