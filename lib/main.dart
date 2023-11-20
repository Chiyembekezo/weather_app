import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/presentation/screens/home_screen.dart';
import 'package:weather_app/repositories/weather_repository.dart';
import 'package:weather_app/ui/weather_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final WeatherRepository weatherRepository = WeatherRepository(httpClient: http.Client());

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: weatherRepository,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Weather App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: WeatherScreen(),
      ),
    );
    // return MaterialApp(
    //     debugShowCheckedModeBanner: false,
    //     home: BlocProvider<CounterCubitCubit>(
    //       create: (context) => CounterCubitCubit(),
    //       child: HomeScreen(title: 'Counter App',),
    //   ),
    // );
  }
}

