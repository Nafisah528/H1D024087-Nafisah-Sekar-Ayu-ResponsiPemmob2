class CurrentWeather {
  final String time;
  final double temperature; // current.temperature_2m
  final int relativeHumidity; // current.relative_humidity_2m
  final double apparentTemperature; // current.apparent_temperature
  final double precipitation; // current.precipitation
  final int weatherCode; // current.weather_code
  final double windSpeed; // current.wind_speed_10m

  CurrentWeather({
    required this.time,
    required this.temperature,
    required this.relativeHumidity,
    required this.apparentTemperature,
    required this.precipitation,
    required this.weatherCode,
    required this.windSpeed,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      time: json['time'] as String? ?? '',
      temperature: (json['temperature_2m'] as num?)?.toDouble() ?? 0.0,
      relativeHumidity: (json['relative_humidity_2m'] as num?)?.toInt() ?? 0,
      apparentTemperature: (json['apparent_temperature_2m'] ?? json['apparent_temperature'] as num?)?.toDouble() ?? 0.0,
      precipitation: (json['precipitation'] as num?)?.toDouble() ?? 0.0,
      weatherCode: (json['weather_code'] as num?)?.toInt() ?? 0,
      windSpeed: (json['wind_speed_10m'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class DailyForecast {
  final String date;
  final int weatherCode;
  final double tempMax; // daily.temperature_2m_max
  final double tempMin; // daily.temperature_2m_min
  final int precipitationProbabilityMax; // daily.precipitation_probability_max

  DailyForecast({
    required this.date,
    required this.weatherCode,
    required this.tempMax,
    required this.tempMin,
    required this.precipitationProbabilityMax,
  });
}

class WeatherModel {
  final double latitude;
  final double longitude;
  final String timezone;
  final CurrentWeather current;
  final List<DailyForecast> daily;

  WeatherModel({
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.current,
    required this.daily,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final currentJson = json['current'] as Map<String, dynamic>? ?? {};
    final dailyJson = json['daily'] as Map<String, dynamic>? ?? {};

    final times = (dailyJson['time'] as List<dynamic>?) ?? [];
    final weatherCodes = (dailyJson['weather_code'] as List<dynamic>?) ?? [];
    final tempMaxs = (dailyJson['temperature_2m_max'] as List<dynamic>?) ?? [];
    final tempMins = (dailyJson['temperature_2m_min'] as List<dynamic>?) ?? [];
    final precipProbs = (dailyJson['precipitation_probability_max'] as List<dynamic>?) ?? [];

    final dailyList = <DailyForecast>[];
    for (int i = 0; i < times.length; i++) {
      dailyList.add(
        DailyForecast(
          date: times[i].toString(),
          weatherCode: i < weatherCodes.length ? (weatherCodes[i] as num).toInt() : 0,
          tempMax: i < tempMaxs.length ? (tempMaxs[i] as num).toDouble() : 0.0,
          tempMin: i < tempMins.length ? (tempMins[i] as num).toDouble() : 0.0,
          precipitationProbabilityMax:
              i < precipProbs.length ? (precipProbs[i] as num).toInt() : 0,
        ),
      );
    }

    return WeatherModel(
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      timezone: json['timezone'] as String? ?? 'auto',
      current: CurrentWeather.fromJson(currentJson),
      daily: dailyList,
    );
  }
}
