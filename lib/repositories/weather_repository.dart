import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../models/weather_data.dart';

class WeatherRepository {
  final http.Client httpClient;
  final String apiKey = '7YKLHECKV9EDWAHLDEF2NSFDN';

  WeatherRepository({required this.httpClient});

  Future<WeatherData?> fetchHourlyWeather(String location) async {
    print('This Is The City: $location');
    const String baseUrl = 'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline';
    final url = Uri.parse('$baseUrl/$location?key=$apiKey&unitGroup=metric&include=days,current,hours,alerts,events');

    try {
      final response = await httpClient.get(url);
      if (response.statusCode == 200) {
        return WeatherData.fromJson(json.decode(response.body));
      } else if (response.statusCode == 400) {
        throw Exception('Invalid location. Please enter a valid city name.');
      } else {
        print('Failed to fetch weather data: ${response.statusCode}');
        throw Exception('Error fetching weather data: HTTP status ${response.statusCode}');
      }
    } on SocketException {
      print('No Internet connection.');
      throw Exception('No Internet connection.');
    } on FormatException {
      print('Bad response format.');
      throw Exception('Bad response format.');
    } on Exception catch (e) {
      print('Exception during fetch: $e');
      throw Exception('Error fetching weather data: $e');
    }
    // Return a default state or handle the failed state appropriately
    return null; // Implement an empty constructor to handle failed state
  }
}
