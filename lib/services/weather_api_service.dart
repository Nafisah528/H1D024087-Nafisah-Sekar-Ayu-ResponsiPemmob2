import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/location_model.dart';
import '../models/weather_model.dart';

class WeatherApiService {
  static const String _forecastBaseUrl = 'https://api.open-meteo.com/v1/forecast';
  static const String _geocodingBaseUrl = 'https://geocoding-api.open-meteo.com/v1/search';
  static const Duration _timeout = Duration(seconds: 12);

  final http.Client _client;

  WeatherApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Mengambil data cuaca berdasarkan koordinat latitude & longitude
  Future<WeatherModel> fetchWeather({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.parse(
      '$_forecastBaseUrl?'
      'latitude=$latitude&'
      'longitude=$longitude&'
      'current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m&'
      'daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max&'
      'timezone=auto',
    );

    try {
      final response = await _client.get(uri).timeout(_timeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
        return WeatherModel.fromJson(data);
      } else {
        throw HttpException(
          'Gagal mengambil data cuaca (Status: ${response.statusCode})',
        );
      }
    } on SocketException {
      throw const SocketException('Tidak dapat terhubung ke server. Periksa koneksi internet Anda.');
    } on TimeoutException {
      throw TimeoutException('Permintaan cuaca melebihi batas waktu (timeout). Coba lagi nanti.');
    } catch (e) {
      if (e is SocketException || e is TimeoutException || e is HttpException) {
        rethrow;
      }
      throw Exception('Terjadi kesalahan saat memproses data cuaca: $e');
    }
  }

  /// Mencari lokasi kota berdasarkan input nama menggunakan Open-Meteo Geocoding API
  Future<List<LocationModel>> searchLocation(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];

    final uri = Uri.parse(
      '$_geocodingBaseUrl?'
      'name=${Uri.encodeComponent(trimmed)}&'
      'count=10&'
      'language=id&'
      'format=json',
    );

    try {
      final response = await _client.get(uri).timeout(_timeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
        final results = data['results'] as List<dynamic>?;

        if (results == null || results.isEmpty) {
          return [];
        }

        return results
            .map((item) => LocationModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw HttpException('Pencarian lokasi gagal (Status: ${response.statusCode})');
      }
    } on SocketException {
      throw const SocketException('Tidak dapat terhubung ke server pencarian. Periksa koneksi internet Anda.');
    } on TimeoutException {
      throw TimeoutException('Pencarian lokasi melebihi batas waktu (timeout). Coba lagi.');
    } catch (e) {
      if (e is SocketException || e is TimeoutException || e is HttpException) {
        rethrow;
      }
      throw Exception('Gagal melakukan pencarian lokasi: $e');
    }
  }
}
