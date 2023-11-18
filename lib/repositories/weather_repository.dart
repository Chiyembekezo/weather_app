import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/weather_data.dart';

class WeatherRepository {
  final http.Client httpClient;
  final String apiKey = '7YKLHECKV9EDWAHLDEF2NSFDN';

  WeatherRepository({required this.httpClient});

  Future<WeatherData> fetchHourlyWeather(String location) async {
    const String baseUrl = 'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline';
    final url = Uri.parse('$baseUrl/$location?key=$apiKey&unitGroup=metric&include=days%2Ccurrent%2Chours%2Calerts%2Cevents');

    final response = await httpClient.get(url);

    if (response.statusCode != 200) {
      throw Exception('Error fetching weather data');
    }

    return WeatherData.fromJson(json.decode(response.body));
  }
}
