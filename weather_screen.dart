import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/hourly_forecast.dart';
import 'package:weather_app/additional_info_card.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String city = 'London';
      final res = await http.get(
        Uri.parse(
            "http://api.openweathermap.org/data/2.5/forecast?q=$city,&APPID=$openweatherAPIKEY"),
      );

      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'Unexpected Error Occured';
      }

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh),
          ),
        ],
        title: const Center(
          child: Text(
            "Weather App",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LinearProgressIndicator(minHeight: 6);
          }

          if (snapshot.hasError) {
            return Text(snapshot.hasError.toString());
          }

          final data = snapshot.data!;

          final currentTemp = data['list'][0]['main']['temp'];
          final currentSky = data['list'][0]['weather'][0]['main'];
          final currentPressure = data['list'][0]['main']['pressure'];
          final currentWindSpeed = data['list'][0]['wind']['speed'];
          final currentHumidity = data['list'][0]['main']['humidity'];
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            "$currentTemp K",
                            style: const TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Icon(
                              currentSky == 'Rain' || currentSky == 'Clouds'
                                  ? Icons.cloud_sharp
                                  : Icons.sunny,
                              size: 60),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            "$currentSky",
                            style: const TextStyle(
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Hourly Forecast",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 1; i < 28; i++)
                        HourlyForecastItem(
                          time: DateFormat.Hm().format(
                              DateTime.parse(data['list'][i]['dt_txt'])),
                          icon: currentSky == 'Rain' || currentSky == 'Clouds'
                              ? Icons.cloud_sharp
                              : Icons.sunny,
                          temp: data['list'][i]['main']['temp'].toString(),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Additional Information",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    additional_info_card(
                        icon: Icons.water_drop,
                        label: "Humidity",
                        value: currentHumidity.toString()),
                    additional_info_card(
                        icon: Icons.air,
                        label: "Wind Speed",
                        value: currentWindSpeed.toString()),
                    additional_info_card(
                        icon: Icons.umbrella,
                        label: "Pressure",
                        value: currentPressure.toString()),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
