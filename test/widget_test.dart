import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/models/location_model.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/utils/weather_utils.dart';

void main() {
  group('LocationModel Tests', () {
    test('fromJson and toJson should correctly serialize and deserialize', () {
      final json = {
        'id': 1642911,
        'name': 'Jakarta',
        'latitude': -6.2146,
        'longitude': 106.8451,
        'country': 'Indonesia',
        'admin1': 'DKI Jakarta',
        'timezone': 'Asia/Jakarta',
      };

      final location = LocationModel.fromJson(json);

      expect(location.name, 'Jakarta');
      expect(location.latitude, -6.2146);
      expect(location.longitude, 106.8451);
      expect(location.country, 'Indonesia');
      expect(location.admin1, 'DKI Jakarta');
      expect(location.fullDisplayName, 'Jakarta, DKI Jakarta, Indonesia');

      final serialized = location.toJson();
      expect(serialized['id'], 1642911);
      expect(serialized['name'], 'Jakarta');
    });

    test('toJsonString and fromJsonString should work symmetrically', () {
      final location = LocationModel(
        id: 1,
        name: 'Bandung',
        latitude: -6.9175,
        longitude: 107.6191,
        country: 'Indonesia',
        admin1: 'Jawa Barat',
      );

      final str = location.toJsonString();
      final revived = LocationModel.fromJsonString(str);

      expect(revived.name, 'Bandung');
      expect(revived.latitude, -6.9175);
      expect(revived.longitude, 107.6191);
      expect(revived, location);
    });
  });

  group('WeatherModel Tests', () {
    test('fromJson should parse Open-Meteo payload properly', () {
      final mockJson = {
        'latitude': -6.21,
        'longitude': 106.84,
        'timezone': 'Asia/Jakarta',
        'current': {
          'time': '2026-11-25T13:00',
          'temperature_2m': 31.5,
          'relative_humidity_2m': 72,
          'apparent_temperature': 37.0,
          'precipitation': 0.5,
          'weather_code': 61,
          'wind_speed_10m': 12.4,
        },
        'daily': {
          'time': ['2026-11-25', '2026-11-26'],
          'weather_code': [61, 0],
          'temperature_2m_max': [33.0, 32.0],
          'temperature_2m_min': [24.0, 23.5],
          'precipitation_probability_max': [80, 20],
        },
      };

      final weather = WeatherModel.fromJson(mockJson);

      expect(weather.latitude, -6.21);
      expect(weather.longitude, 106.84);
      expect(weather.timezone, 'Asia/Jakarta');

      // Current
      expect(weather.current.temperature, 31.5);
      expect(weather.current.relativeHumidity, 72);
      expect(weather.current.apparentTemperature, 37.0);
      expect(weather.current.precipitation, 0.5);
      expect(weather.current.weatherCode, 61);
      expect(weather.current.windSpeed, 12.4);

      // Daily
      expect(weather.daily.length, 2);
      expect(weather.daily[0].date, '2026-11-25');
      expect(weather.daily[0].weatherCode, 61);
      expect(weather.daily[0].tempMax, 33.0);
      expect(weather.daily[0].tempMin, 24.0);
      expect(weather.daily[0].precipitationProbabilityMax, 80);

      expect(weather.daily[1].weatherCode, 0);
      expect(weather.daily[1].tempMax, 32.0);
    });
  });

  group('WeatherUtils Tests', () {
    test('getCondition should return proper descriptions and icons', () {
      final clear = WeatherUtils.getCondition(0);
      expect(clear.description, 'Cerah');

      final rain = WeatherUtils.getCondition(61);
      expect(rain.description, 'Hujan Ringan');

      final storm = WeatherUtils.getCondition(95);
      expect(storm.description, 'Badai Petir');
    });

    test('formatDayName formats index 0 and 1 correctly', () {
      expect(WeatherUtils.formatDayName('2026-11-25', 0), 'Hari Ini');
      expect(WeatherUtils.formatDayName('2026-11-26', 1), 'Besok');
    });
  });
}
