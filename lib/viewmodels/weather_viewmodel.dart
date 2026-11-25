import 'package:flutter/foundation.dart';
import '../models/location_model.dart';
import '../models/weather_model.dart';
import '../services/local_storage_service.dart';
import '../services/weather_api_service.dart';

class WeatherViewModel extends ChangeNotifier {
  final WeatherApiService _apiService;
  final LocalStorageService _storageService;

  WeatherViewModel({
    WeatherApiService? apiService,
    LocalStorageService? storageService,
  })  : _apiService = apiService ?? WeatherApiService(),
        _storageService = storageService ?? LocalStorageService();

  LocationModel? _currentLocation;
  WeatherModel? _weatherData;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isCurrentFavorite = false;

  LocationModel? get currentLocation => _currentLocation;
  WeatherModel? get weatherData => _weatherData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isCurrentFavorite => _isCurrentFavorite;

  /// Default lokasi awal jika belum ada data yang tersimpan
  static final LocationModel defaultLocation = LocationModel(
    id: 1642911,
    name: 'Jakarta',
    latitude: -6.2146,
    longitude: 106.8451,
    country: 'Indonesia',
    admin1: 'DKI Jakarta',
    timezone: 'Asia/Jakarta',
  );

  /// Inisialisasi awal saat aplikasi dibuka:
  /// Membaca lokasi terakhir dari local storage atau menggunakan default
  Future<void> initialize() async {
    final savedLocation = await _storageService.getLastLocation();
    final targetLocation = savedLocation ?? defaultLocation;
    await fetchWeatherForLocation(targetLocation);
  }

  /// Mengambil data cuaca dari API untuk lokasi tertentu
  Future<void> fetchWeatherForLocation(LocationModel location) async {
    _currentLocation = location;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simpan lokasi terpilih ke penyimpanan lokal
      await _storageService.saveLastLocation(location);

      // Cek status favorit
      _isCurrentFavorite = await _storageService.isFavorite(location);

      // Request API cuaca Open-Meteo
      final weather = await _apiService.fetchWeather(
        latitude: location.latitude,
        longitude: location.longitude,
      );

      _weatherData = weather;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Memperbarui data cuaca lokasi saat ini (pull-to-refresh)
  Future<void> refreshWeather() async {
    if (_currentLocation != null) {
      await fetchWeatherForLocation(_currentLocation!);
    } else {
      await initialize();
    }
  }

  /// Toggle bookmark favorit untuk lokasi yang sedang aktif
  Future<void> toggleCurrentFavorite() async {
    if (_currentLocation == null) return;

    if (_isCurrentFavorite) {
      await _storageService.removeFavorite(_currentLocation!);
      _isCurrentFavorite = false;
    } else {
      await _storageService.addFavorite(_currentLocation!);
      _isCurrentFavorite = true;
    }
    notifyListeners();
  }

  /// Sinkronisasi status favorit saat kembali dari halaman lain
  Future<void> checkFavoriteStatus() async {
    if (_currentLocation != null) {
      _isCurrentFavorite = await _storageService.isFavorite(_currentLocation!);
      notifyListeners();
    }
  }
}
