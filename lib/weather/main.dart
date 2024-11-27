// lib/main.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:testimn/weather/test/weather_service.dart';

import 'package:weather_icons/weather_icons.dart';

// import 'weather_service.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue, // Primary color for the app
        scaffoldBackgroundColor: Colors.black, // Black background
      ),
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  String _city = 'Rajshahi'; // Default city
  Map<String, dynamic>? _weatherData;
  bool _isLoading = false;
  final TextEditingController _cityController = TextEditingController();
  Timer? _timer;
  String _currentTime = '';
  String _sunriseCountdown = '';
  String _sunsetCountdown = '';

  void _fetchWeather() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final data = await _weatherService.fetchWeather(_city);
      setState(() {
        _weatherData = data;
        _startCountdowns();
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _startCountdowns() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final sunrise = DateTime.fromMillisecondsSinceEpoch(
          _weatherData!['sys']['sunrise'] * 1000);
      final sunset = DateTime.fromMillisecondsSinceEpoch(
          _weatherData!['sys']['sunset'] * 1000);

      setState(() {
        _currentTime = TimeOfDay.now().format(context);
        _sunriseCountdown = _getTimeRemaining(now, sunrise);
        _sunsetCountdown = _getTimeRemaining(now, sunset);
      });
    });
  }

  String _getTimeRemaining(DateTime now, DateTime target) {
    final difference = target.difference(now);
    if (difference.isNegative) return 'Passed';
    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);
    final seconds = difference.inSeconds.remainder(60);
    return '${hours}h ${minutes}m ${seconds}s';
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
    _startCountdowns();
  }

  @override
  void dispose() {
    _cityController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Widget _buildCityInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _cityController,
              decoration: InputDecoration(
                hintText: 'Enter city name',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[900], // Dark grey for input field
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _cityController.clear();
                  },
                ),
              ),
              style: TextStyle(color: Colors.white), // White text color
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    _city = value;
                  });
                  _fetchWeather();
                }
              },
            ),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              if (_cityController.text.isNotEmpty) {
                setState(() {
                  _city = _cityController.text;
                });
                _fetchWeather();
              }
            },
            child: Text('Get Weather'),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherData() {
    if (_weatherData == null) {
      return Center(
        child: Text(
          'No weather data available',
          style: TextStyle(color: Colors.white), // White color for text
        ),
      );
    }

    final sunriseTime = DateTime.fromMillisecondsSinceEpoch(
        _weatherData!['sys']['sunrise'] * 1000);
    final sunsetTime = DateTime.fromMillisecondsSinceEpoch(
        _weatherData!['sys']['sunset'] * 1000);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Weather in ${_weatherData!['name']}',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.lightBlueAccent, // Colored city name
              ),
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: Text(
              '${_weatherData!['main']['temp']}°C',
              style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: Colors.yellowAccent, // Colored temperature
              ),
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: Text(
              'Current Time: $_currentTime',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                Text(
                  'Sunrise: ${sunriseTime.hour}:${sunriseTime.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.orangeAccent), // Sunrise time color
                ),
                Text(
                  'Sunset: ${sunsetTime.hour}:${sunsetTime.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.pinkAccent), // Sunset time color
                ),
                Text(
                  'Sunrise in: $_sunriseCountdown',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.orangeAccent),
                ),
                Text(
                  'Sunset in: $_sunsetCountdown',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.pinkAccent),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Divider(
              thickness: 2,
              color: Colors.white), // White divider for separation
          SizedBox(height: 16),
          _buildWeatherInfoRow(
            FontAwesomeIcons.thermometerHalf,
            'Temperature',
            '${_weatherData!['main']['temp']}°C',
          ),
          _buildWeatherInfoRow(
            FontAwesomeIcons.thermometerFull,
            'Feels Like',
            '${_weatherData!['main']['feels_like']}°C',
          ),
          _buildWeatherInfoRow(
            FontAwesomeIcons.cloud,
            'Weather',
            '${_weatherData!['weather'][0]['main']} - ${_weatherData!['weather'][0]['description']}',
          ),
          _buildWeatherInfoRow(
            FontAwesomeIcons.wind,
            'Wind Speed',
            '${_weatherData!['wind']['speed']} m/s',
          ),
          _buildWeatherInfoRow(
            WeatherIcons.humidity,
            'Humidity',
            '${_weatherData!['main']['humidity']}%',
          ),
          _buildWeatherInfoRow(
            WeatherIcons.barometer,
            'Pressure',
            '${_weatherData!['main']['pressure']} hPa',
          ),
          _buildWeatherInfoRow(
            FontAwesomeIcons.eye,
            'Visibility',
            '${_weatherData!['visibility']} meters',
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.white), // White color for icons
          SizedBox(width: 10),
          Text(
            '$label: ',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white), // White color for text
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                  fontSize: 16, color: Colors.white), // White color for text
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildCityInput(),
                  _buildWeatherData(),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchWeather,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
