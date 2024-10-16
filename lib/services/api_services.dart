// import 'package:http/http.dart' as http;
// import 'package:weather_app/const/string.dart';
// import 'package:weather_app/models/hourly_weather_model.dart';

// var hourlylink =
//     'api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric';

// getHourlyWeather() async {
//   var res = await http.get(Uri.parse(hourlylink));

//   if (res.statusCode == 200) {
//     var data = hourlyWeatherDataFromJson(res.body.toString());
//     print('data is recieved');
//     print(data.message);
//     return data;
//   }
// }

import 'dart:convert';

import 'package:http/http.dart' as http;

class WeatherService {
  final String weatherapikey = 'c47fb58d7cee4797a1c111050241407';
  final forecastbaseUrl = 'http://api.weatherapi.com/v1/forecast.json';
  final searchBaseUrl = 'http://api.weatherapi.com/v1/search.json';

  Future<Map<String, dynamic>> fetch7DaysForecast(String city) async {
    final url =
        '$forecastbaseUrl?key=$weatherapikey&q=$city&days=7&aqi=no8alerts=no';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed  to load 7days weather data');
    }
  }

  Future<List<dynamic>?> fetchCitySuggest(String query) async {
    final url = '$searchBaseUrl?key=$weatherapikey&q=$query';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }
}
