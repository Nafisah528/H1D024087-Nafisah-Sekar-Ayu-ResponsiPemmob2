import 'package:flutter/foundation.dart';
import '../models/location_model.dart';
import '../services/local_storage_service.dart';
import '../services/weather_api_service.dart';

class SearchViewModel extends ChangeNotifier {
  final WeatherApiService _apiService;
  final LocalStorageService _storageService;

  SearchViewModel({
    WeatherApiService? apiService,
    LocalStorageService? storageService,
  })  : _apiService = apiService ?? WeatherApiService(),
        _storageService = storageService ?? LocalStorageService();

  List<LocationModel> _searchResults = [];
  List<LocationModel> _favorites = [];
  List<LocationModel> _searchHistory = [];
  bool _isSearching = false;
  String? _searchError;
  String _currentQuery = '';

  List<LocationModel> get searchResults => _searchResults;
  List<LocationModel> get favorites => _favorites;
  List<LocationModel> get searchHistory => _searchHistory;
  bool get isSearching => _isSearching;
  String? get searchError => _searchError;
  String get currentQuery => _currentQuery;

  /// Memuat data favorit dan riwayat pencarian dari Local Storage
  Future<void> loadFavoritesAndHistory() async {
    _favorites = await _storageService.getFavorites();
    _searchHistory = await _storageService.getSearchHistory();
    notifyListeners();
  }

  /// Melakukan pencarian lokasi ke Open-Meteo Geocoding API
  Future<void> search(String query) async {
    _currentQuery = query;
    final trimmed = query.trim();

    if (trimmed.isEmpty) {
      _searchResults = [];
      _searchError = null;
      _isSearching = false;
      notifyListeners();
      return;
    }

    _isSearching = true;
    _searchError = null;
    notifyListeners();

    try {
      final results = await _apiService.searchLocation(trimmed);
      _searchResults = results;
      _searchError = null;
    } catch (e) {
      _searchError = e.toString().replaceFirst('Exception: ', '');
      _searchResults = [];
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  /// Menghapus kata kunci dan hasil pencarian
  void clearSearch() {
    _currentQuery = '';
    _searchResults = [];
    _searchError = null;
    _isSearching = false;
    notifyListeners();
  }

  /// Menyimpan lokasi ke riwayat saat dipilih oleh pengguna
  Future<void> recordSelectedLocation(LocationModel location) async {
    await _storageService.addSearchHistory(location);
    _searchHistory = await _storageService.getSearchHistory();
    notifyListeners();
  }

  /// Toggle status favorit suatu lokasi
  Future<void> toggleFavorite(LocationModel location) async {
    final isFav = isLocationFavorite(location);
    if (isFav) {
      await _storageService.removeFavorite(location);
    } else {
      await _storageService.addFavorite(location);
    }
    _favorites = await _storageService.getFavorites();
    notifyListeners();
  }

  /// Memeriksa apakah lokasi berada di daftar favorit
  bool isLocationFavorite(LocationModel location) {
    return _favorites.any((item) => item == location);
  }

  /// Menghapus 1 item dari riwayat pencarian
  Future<void> removeHistoryItem(LocationModel location) async {
    await _storageService.removeSearchHistory(location);
    _searchHistory = await _storageService.getSearchHistory();
    notifyListeners();
  }

  /// Mengosongkan seluruh riwayat pencarian
  Future<void> clearAllHistory() async {
    await _storageService.clearSearchHistory();
    _searchHistory = [];
    notifyListeners();
  }
}
