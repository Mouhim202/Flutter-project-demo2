import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:weather_icons/weather_icons.dart';
import 'package:demo_app_2/widgets/mydrawer.widget.dart';

class MeteoPage extends StatefulWidget {
  const MeteoPage({Key? key}) : super(key: key);

  @override
  _MeteoPageState createState() => _MeteoPageState();
}

class _MeteoPageState extends State<MeteoPage> {
  String city = "Marrakech";
  List<dynamic>? forecast;
  bool isLoading = false;

  Future<void> fetchWeather() async {
    setState(() {
      isLoading = true;
      forecast = null;
    });

    final url = "https://wttr.in/${Uri.encodeComponent(city)}?format=j1";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception("Failed to load weather: ${response.body}");
      }

      final data = json.decode(response.body);

      // wttr.in renvoie plusieurs jours dans data["weather"]
      List<dynamic> hourlyForecast = data["weather"][0]["hourly"];

      setState(() {
        forecast = hourlyForecast;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("❌ Error fetching weather: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching weather: $e")),
      );
    }
  }

  /// Cette version utilise les descriptions wttr.in pour choisir l’icône
  IconData _getWeatherIcon(String? condition) {
    if (condition == null) return WeatherIcons.na;

    final lower = condition.toLowerCase();

    if (lower.contains("sun") || lower.contains("clear")) {
      return WeatherIcons.day_sunny;
    } else if (lower.contains("partly cloudy")) {
      return WeatherIcons.day_cloudy;
    } else if (lower.contains("cloud")) {
      return WeatherIcons.cloud;
    } else if (lower.contains("rain") || lower.contains("drizzle")) {
      return WeatherIcons.rain;
    } else if (lower.contains("thunder")) {
      return WeatherIcons.thunderstorm;
    } else if (lower.contains("snow")) {
      return WeatherIcons.snow;
    } else if (lower.contains("fog") ||
        lower.contains("mist") ||
        lower.contains("haze")) {
      return WeatherIcons.fog;
    } else if (lower.contains("overcast")) {
      return WeatherIcons.cloudy;
    } else {
      return WeatherIcons.na;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(title: const Text("Weather Forecast")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Enter a city...",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => city = value,
              onSubmitted: (value) {
                city = value;
                fetchWeather();
              },
            ),
          ),
          ElevatedButton(
            onPressed: fetchWeather,
            child: const Text("Get Weather"),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : forecast == null
                ? const Center(child: Text("No data available"))
                : ListView.builder(
              itemCount: forecast!.length,
              itemBuilder: (context, index) {
                final item = forecast![index];
                final time = item["time"] ?? "0";
                final temp = item["tempC"] ?? "N/A";
                final desc = (item["weatherDesc"] != null &&
                    item["weatherDesc"].isNotEmpty)
                    ? item["weatherDesc"][0]["value"]
                    : "Unknown";

                return Card(
                  color: Colors.deepOrangeAccent,
                  child: ListTile(
                    leading: BoxedIcon(
                      _getWeatherIcon(desc),
                      color: Colors.white,
                      size: 36,
                    ),
                    title: Text(
                      "Heure: $time",
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "$desc | $temp°C",
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
