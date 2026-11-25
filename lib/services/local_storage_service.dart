import 'package:shared_preferences/shared_preferences.dart';
import '../models/location_model.dart';

class LocalStorageService {
  static const String _keyFavorites = 'favorite_locations';
  static const String _keyHistory = 'search_history';
  static const String _keyLastLocation = 'last_selected_location';

  /// Mendapatkan daftar lokasi favorit yang tersimpan
  Future<List<LocationModel>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final stringList = prefs.getStringList(_keyFavorites) ?? [];

    final result = <LocationModel>[];
    for (final jsonStr in stringList) {
      try {
        result.add(LocationModel.fromJsonString(jsonStr));
      } catch (_) {}
    }
    return result;
  }

  /// Menambahkan lokasi ke favorit
  Future<void> addFavorite(LocationModel location) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();

    // Cek apakah sudah ada (hindari duplikasi)
    if (!favorites.any((item) => item == location)) {
      favorites.insert(0, location);
      final stringList = favorites.map((loc) => loc.toJsonString()).toList();
      await prefs.setStringList(_keyFavorites, stringList);
    }
  }

  /// Menghapus lokasi dari favorit
  Future<void> removeFavorite(LocationModel location) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();

    favorites.removeWhere((item) => item == location);
    final stringList = favorites.map((loc) => loc.toJsonString()).toList();
    await prefs.setStringList(_keyFavorites, stringList);
  }

  /// Memeriksa apakah lokasi berstatus favorit
  Future<bool> isFavorite(LocationModel location) async {
    final favorites = await getFavorites();
    return favorites.any((item) => item == location);
  }

  /// Mendapatkan riwayat pencarian
  Future<List<LocationModel>> getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final stringList = prefs.getStringList(_keyHistory) ?? [];

    final result = <LocationModel>[];
    for (final jsonStr in stringList) {
      try {
        result.add(LocationModel.fromJsonString(jsonStr));
      } catch (_) {}
    }
    return result;
  }

  /// Menyimpan lokasi ke riwayat pencarian (maksimal 15 item terbaru)
  Future<void> addSearchHistory(LocationModel location) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getSearchHistory();

    // Hapus duplikat lama jika ada
    history.removeWhere((item) => item == location);
    // Tambah di awal (paling baru)
    history.insert(0, location);

    // Batasi 15 riwayat terbaru
    if (history.length > 15) {
      history.removeRange(15, history.length);
    }

    final stringList = history.map((loc) => loc.toJsonString()).toList();
    await prefs.setStringList(_keyHistory, stringList);
  }

  /// Menghapus satu item dari riwayat
  Future<void> removeSearchHistory(LocationModel location) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getSearchHistory();

    history.removeWhere((item) => item == location);
    final stringList = history.map((loc) => loc.toJsonString()).toList();
    await prefs.setStringList(_keyHistory, stringList);
  }

  /// Menghapus seluruh riwayat pencarian
  Future<void> clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyHistory);
  }

  /// Menyimpan lokasi terakhir yang sedang dibuka pengguna
  Future<void> saveLastLocation(LocationModel location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastLocation, location.toJsonString());
  }

  /// Membaca lokasi terakhir yang dibuka pengguna
  Future<LocationModel?> getLastLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyLastLocation);
    if (jsonStr != null && jsonStr.isNotEmpty) {
      try {
        return LocationModel.fromJsonString(jsonStr);
      } catch (_) {}
    }
    return null;
  }
}
