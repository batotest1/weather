import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: WeatherScreen(),
  ));
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String cityName = "Kokand";
  double tempC = 0.0;
  String conditionText = "";
  String sunrise = "";
  String sunset = "";
  double tempMin = 0.0;
  double tempMax = 0.0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    try {
      String apiKey = "40b2851af21546fbbd294943232312";
      String apiUrl =
          "http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$cityName&days=1&aqi=no&alerts=no";

      final response = await http.get(Uri.parse(apiUrl));
      final data = jsonDecode(response.body);

      setState(() {
        cityName = data['location']['name'];
        tempC = data['current']['temp_c'];
        conditionText = data['current']['condition']['text'];
        sunrise = data['forecast']['forecastday'][0]['astro']['sunrise'];
        sunset = data['forecast']['forecastday'][0]['astro']['sunset'];
        tempMin = data['forecast']['forecastday'][0]['day']['mintemp_c'];
        tempMax = data['forecast']['forecastday'][0]['day']['maxtemp_c'];

        // Haftaning kunini olish
      });
    } catch (e) {
      print("Error fetching weather: $e");
    } finally {
      setState(() {
        loading = false; // Fetching tugagandan keyin loading holatini false qilamiz
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.purple, Colors.pink, Colors.orange],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.2, 0.5, 0.8, 1.0],
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "📍 $cityName",
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                    ),
                    Spacer(),
                    Text(
                      "Good Afternoon",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),

                    SizedBox(height: 17),
                    Image.asset(
                      'images/7.png',
                      height: 200,
                      width: 200,
                    ),
                    Text(
                      "$tempC°C",
                      style: TextStyle(
                          fontSize: 48,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "$conditionText",
                      style: TextStyle(color: Colors.white54, fontSize: 20),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "${DateFormat.EEEE().format(DateTime.now())} • ${DateTime.now().toLocal().hour}:${DateTime.now().toLocal().minute}",
                      style: TextStyle(color: Colors.white54, fontSize: 16),
                    ),
                    Spacer(),
                    Divider(color: Colors.white54, indent: 20, endIndent: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Image.asset(
                                'images/11.png',
                                width: 40,
                                height: 40,
                              ),
                              SizedBox(height: 5),
                              Text("Sunrise",
                                  style: TextStyle(color: Colors.white54)),
                              Text(sunrise,
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                          Column(
                            children: [
                              Image.asset(
                                'images/12.png',
                                width: 40,
                                height: 40,
                              ),
                              SizedBox(height: 5),
                              Text("Sunset",
                                  style: TextStyle(color: Colors.white54)),
                              Text(sunset,
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Image.asset(
                              'images/13.png',
                              width: 40,
                              height: 40,
                            ),
                            Text("Temp Max",
                                style: TextStyle(color: Colors.white54)),
                            Text("$tempMax°C",
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        Column(
                          children: [
                            Image.asset(
                              'images/14.png',
                              width: 40,
                              height: 40,
                            ),
                            Text("Temp Min",
                                style: TextStyle(color: Colors.white54)),
                            Text("$tempMin°C",
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
    );
  }
}
