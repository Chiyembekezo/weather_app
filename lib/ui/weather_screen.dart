import 'dart:async';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/widgets/icons.dart';
import '../blocs/weather/weather_bloc.dart';
import '../models/weather_data.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  String _currentCity = '';
  late final String _currentTime;
  late Ticker _ticker;

  String formattedDate = '';

  @override
  void initState() {
    super.initState();
    _fetchWeatherWithLocation();
    _currentTime = _formatDateTime(DateTime.now());
  }

  String _formatDateTime(DateTime dateTime) {
    // This line uses the DateFormat class to format your date as you specified.
    // 'd' stands for day, 'MMMM' for full month name, and 'y' for year.
    // However, 'd' won't automatically put 'th', 'nd', 'rd', or 'st' after the day number.
    var formattedDate = DateFormat('d MMMM, y').format(dateTime);

    // The following lines will manually append the correct suffix to the day.
    var dayNumber = int.parse(DateFormat('d').format(dateTime));
    String suffix;
    var digit = dayNumber % 10;
    if ((digit > 0 && digit < 4) && (dayNumber < 11 || dayNumber > 13)) {
      suffix = ['th', 'st', 'nd', 'rd'][digit];
    } else {
      suffix = 'th';
    }

    // Putting it all together to get the date in the format "27th October, 2023".
    // We insert the suffix right after the day number.
    return formattedDate.replaceFirst(DateFormat('d').format(dateTime), dayNumber.toString() + suffix);
  }

  @override
  void dispose() {
    _cityController.dispose();
    _ticker.dispose();
    super.dispose();
  }

  Future<String> convertCoordinatesToCityName(double latitude, double longitude) async {
    try {
      List<Placemark> placeMarks = await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placeMarks[0];
      print('Locality: ${place.locality}');
      return "${place.locality}";
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
        setState(() {
          _currentCity = cityName;
        });
        context.read<WeatherBloc>().add(FetchWeather(cityName));
      } else {
        print('Could not determine city from location');
      }
    } catch (e) {
      print('Failed to get location or city name: $e');
      // You might want to display some error to the user or have a fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: Column(
          children: [
            const SizedBox(height: 40,),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: SvgPicture.asset(AppIcons.back),
                  ),
                  Column(
                    children: [
                      Text('Weather App', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),),
                      Text(_currentTime, style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 12),),
                    ],
                  ),
                  SvgPicture.asset(AppIcons.mode)
                ],
              ),
            ),
        TextField(
                controller: _cityController,
                decoration: InputDecoration(
                  hintText: 'Enter a city', // 'hintText' is used instead of 'labelText' for placeholder text.
                  filled: true, // Fills the background color of the TextField.
                  fillColor: const Color(0xffD4E7FB), // Background color of the TextField.
                  prefixIcon: const Icon(Icons.search), // Prefix icon, the search icon inside the TextField.
                  suffixIcon: _cityController.text.isNotEmpty // Conditionally display the clear button.
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _cityController.clear(); // Clears the TextField.
                    },
                  )
                      : null,
                  border: OutlineInputBorder( // Defines the border of the TextField.
                    borderRadius: BorderRadius.circular(10.0), // Makes the border rounded.
                    borderSide: BorderSide.none, // Removes the underline of the TextField border.
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0), // Adjusts the padding inside the TextField.
                ),
                onChanged: (value) {
                  setState(() {}); // Call setState to toggle the clear button when typing.
                },
                onSubmitted: (value) {
                  // Your search logic when the user submits the form.
                },
              ),const SizedBox(height: 20,),
            Expanded(child: WeatherView(currentCity: _currentCity),),
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
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}

class WeatherView extends StatelessWidget {
  final String currentCity;
  const WeatherView({Key? key, required this.currentCity}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state is WeatherInitialState) {
          //context.read<WeatherBloc>().add(FetchWeather(currentCity));
          return const Center(child: CircularProgressIndicator());
        } else if (state is WeatherLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is WeatherLoadedState) {
          final currentWeather = state.weatherData.currentConditions; // Assuming this is how you access the current conditions

          // Convert the Conditions enum to a readable string
          String conditionsString = currentWeather.conditions != null
              ? conditionsValues.reverse[currentWeather.conditions]!
              : ' Not available';
          String descriptionString = currentWeather.description != null
              ? conditionsValues.reverse[currentWeather.description]!
              : 'Not available';

          String svgImagePath = '';

          bool isNightTime =
              DateTime.now().hour >= 18 || DateTime.now().hour <= 4;

          if ( conditionsString == 'Partially cloudy') {
            svgImagePath = isNightTime
                ? 'assets/Weather-Partially-Cloudy-Night.svg'
                : 'assets/Weather-Partially-Cloudy-Day.svg';
          } else if ( conditionsString == 'Clear') {
            svgImagePath = isNightTime
                ? 'assets/Weather-Clear-Night.svg'
                : 'assets/Weather-Clear-Day.svg';
          } else if ( conditionsString == 'Overcast') {
            svgImagePath = isNightTime
                ? 'assets/Weather-Cloudy.svg'
                : 'assets/Weather-Cloudy.svg';
          } else if ( conditionsString == 'Rain') {
            svgImagePath = isNightTime
                ? 'assets/Weather-Raining-Night.svg'
                : 'assets/Weather-Raining-Day.svg';
          } else {
            svgImagePath = 'assets/images/Sunny.svg'; // Default image
          }

          return Column(
              children: [
                CurrentWeatherContainer(
                  svgScr: svgImagePath,
                  currentWeather: currentWeather,
                  conditions: conditionsString,
                  temperature: '${currentWeather.temp}°C',
                  wind: '${currentWeather.windspeed} km/h',
                  visibility: '${currentWeather.visibility} km',
                  humidity: '${currentWeather.humidity}%',
                  rain: '${currentWeather.visibility}',
                  feelsLike: '${currentWeather.feelslike}°C',
                  description: descriptionString,
                ),
                // Refreshable list of hourly or daily forecasts
                Expanded(
                child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<WeatherBloc>().add(FetchWeather(currentCity));
                    },
                    child: ListView.builder(
                      itemCount: state.weatherData.days.length,
                      itemBuilder: (context, index) {
                        final hour = state.weatherData.days[index];
                        return ListTile(
                          title: Text(hour.datetime),
                          subtitle: Text('${hour.temp}°'),
                        );
                      },
                    ),
                  )
                ),
              ],
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

class CurrentWeatherContainer extends StatelessWidget {
  final CurrentConditions currentWeather;
  String svgScr;
  String temperature;
  String conditions;
  String humidity;
  String wind;
  String rain;
  String visibility;
  String feelsLike;
  String description;


  CurrentWeatherContainer({
    super.key,
    required this.svgScr,
    required this.currentWeather,
    required this.conditions,
    required this.temperature,
    required this.humidity,
    required this.visibility,
    required this.rain,
    required this.wind,
    required this.feelsLike,
    required this.description
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xff358dd8),
            Color(0xff0b3e82)
          ]),
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset(
                svgScr, width: 110,),
              Column(
                children: [
                  Text(temperature , style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 50, color: const Color(0xffffffff)),),
                  Text(conditions , style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16, color: const Color(0xffffffff)),),
                  Text( description, style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 14, color: const Color(0xffffffff)),),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [
                  Color(0xff358dd8),
                  Color(0xff0b3e82)
                ]),
                border: Border.all(
                  color: Colors.white, // Border color
                  width: 1.0, // Border width
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SvgPicture.asset(AppIcons.humidity,),
                    Text(humidity , style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 12, color: const Color(0xffffffff)),),
                    Text('Humidity', style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 12, color: const Color(0xffffffff)),),
                  ],
                ),
                Column(
                  children: [
                    SvgPicture.asset(AppIcons.wind,),
                    Text(wind , style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 12, color: const Color(0xffffffff)),),
                    Text('Wind', style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 12, color: const Color(0xffffffff)),),
                  ],
                ),
                Column(
                  children: [
                    SvgPicture.asset(AppIcons.rain,),
                    Text(rain , style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 12, color: const Color(0xffffffff)),),
                    Text('Rainfall', style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 12, color: const Color(0xffffffff)),),
                  ],
                ),
                Column(
                  children: [
                    SvgPicture.asset(AppIcons.visibility,),
                    Text(visibility , style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 12, color: const Color(0xffffffff)),),
                    Text('Visibility', style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 12, color: const Color(0xffffffff)),),
                  ],
                ),
                Column(
                  children: [
                    SvgPicture.asset(AppIcons.temperature,),
                    Text(feelsLike , style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 12, color: const Color(0xffffffff)),),
                    Text('Avg Temp', style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 12, color: const Color(0xffffffff)),),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
