import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../blocs/weather/weather_bloc.dart';
import '../repositories/weather_repository.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchWeatherWithLocation();
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  Future<String> convertCoordinatesToCityName(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];
      return "${place.locality}, ${place.country}";
    } catch (e) {
      print("Failed to convert coordinates to city name: $e");
      return ''; // Return empty string or handle the error appropriately
    }
  }

  void _fetchWeatherWithLocation() async {
    try {
      Position position = await _determinePosition();
      String cityName = await convertCoordinatesToCityName(position.latitude, position.longitude);
      if (cityName.isNotEmpty) {
        context.read<WeatherBloc>().add(FetchWeather(cityName));
      } else {
        print('Could not determine city from location');
        // Handle the case where the city name cannot be determined
      }
    } catch (e) {
      print('Failed to get location: $e');
      // Handle failure to get location
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      body: BlocProvider(
        create: (context) => WeatherBloc(weatherRepository: RepositoryProvider.of<WeatherRepository>(context)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: 'Enter a city',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      String cityName = _cityController.text;
                      if (cityName.isNotEmpty) {
                        context.read<WeatherBloc>().add(FetchWeather(cityName));
                      } else {
                        _fetchWeatherWithLocation();
                      }
                    },
                  ),
                ),
              ),
            ),
            Expanded(child: WeatherView()),
          ],
        ),
      ),
    );
  }

  // A method to determine the position
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled; request user to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try requesting permissions again.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}

class WeatherView extends StatelessWidget {
  const WeatherView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state is WeatherInitialState) {
          context.read<WeatherBloc>().add(FetchWeather('Lusaka'));
          return const Center(child: CircularProgressIndicator());
        } else if (state is WeatherLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is WeatherLoadedState) {
          return ListView.builder(
            itemCount: state.weatherData.days.length,
            itemBuilder: (context, index) {
              final hour = state.weatherData.days[index];
              print('These are the hour: ${hour}');
              return ListTile(
                title: Text(hour.datetime),
                subtitle: Text('${hour.temp}°'),
              );
            },
          );
        } else if (state is WeatherErrorState) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return const Center(child: Text('Something went wrong!'));
        }
      },
    );
  }
}
