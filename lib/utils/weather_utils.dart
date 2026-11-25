import 'package:flutter/material.dart';
import 'app_theme.dart';

class WeatherConditionInfo {
  final String description;
  final IconData icon;
  final Color primaryColor;
  final List<Color> gradientColors;

  WeatherConditionInfo({
    required this.description,
    required this.icon,
    required this.primaryColor,
    required this.gradientColors,
  });
}

class WeatherUtils {
  /// Mengonversi WMO Weather Interpretation Code ke deskripsi bahasa Indonesia,
  /// ikon yang sesuai, dan gradien warna selaras dengan color palette:
  /// Black Pine (#152026), Deep Ocean (#1B3D59), Windstorm (#6A97C0),
  /// Melting Ice (#B3D5F1), Avalanche (#D4EEF8), Sun Beam (#F3EED8).
  static WeatherConditionInfo getCondition(int code) {
    switch (code) {
      case 0: // Cerah
        return WeatherConditionInfo(
          description: 'Cerah',
          icon: Icons.wb_sunny_rounded,
          primaryColor: AppTheme.sunBeam,
          gradientColors: const [
            AppTheme.deepOcean,
            AppTheme.windstorm,
          ],
        );
      case 1: // Cerah Berawan
        return WeatherConditionInfo(
          description: 'Cerah Berawan',
          icon: Icons.wb_sunny_outlined,
          primaryColor: AppTheme.sunBeam,
          gradientColors: const [
            AppTheme.deepOcean,
            Color(0xFF38688E),
          ],
        );
      case 2: // Sebagian Berawan
        return WeatherConditionInfo(
          description: 'Sebagian Berawan',
          icon: Icons.cloud_queue_rounded,
          primaryColor: AppTheme.meltingIce,
          gradientColors: const [
            Color(0xFF1B3D59),
            AppTheme.windstorm,
          ],
        );
      case 3: // Mendung / Berawan Tebal
        return WeatherConditionInfo(
          description: 'Mendung / Berawan Tebal',
          icon: Icons.cloud_rounded,
          primaryColor: AppTheme.meltingIce,
          gradientColors: const [
            AppTheme.blackPine,
            AppTheme.deepOcean,
          ],
        );
      case 45:
      case 48: // Berkabut
        return WeatherConditionInfo(
          description: 'Berkabut',
          icon: Icons.blur_on_rounded,
          primaryColor: AppTheme.meltingIce,
          gradientColors: const [
            AppTheme.windstorm,
            Color(0xFF8EB5D6),
          ],
        );
      case 51:
      case 53:
      case 55: // Gerimis
        return WeatherConditionInfo(
          description: 'Gerimis Ringan',
          icon: Icons.grain_rounded,
          primaryColor: AppTheme.meltingIce,
          gradientColors: const [
            AppTheme.deepOcean,
            Color(0xFF3B6A91),
          ],
        );
      case 61: // Hujan Ringan
        return WeatherConditionInfo(
          description: 'Hujan Ringan',
          icon: Icons.water_drop_rounded,
          primaryColor: AppTheme.meltingIce,
          gradientColors: const [
            AppTheme.deepOcean,
            AppTheme.windstorm,
          ],
        );
      case 63: // Hujan Sedang
        return WeatherConditionInfo(
          description: 'Hujan Sedang',
          icon: Icons.umbrella_rounded,
          primaryColor: AppTheme.meltingIce,
          gradientColors: const [
            Color(0xFF132B40),
            AppTheme.deepOcean,
          ],
        );
      case 65: // Hujan Lebat
        return WeatherConditionInfo(
          description: 'Hujan Lebat',
          icon: Icons.thunderstorm_rounded,
          primaryColor: AppTheme.meltingIce,
          gradientColors: const [
            AppTheme.blackPine,
            Color(0xFF16344D),
          ],
        );
      case 71:
      case 73:
      case 75:
      case 77: // Bersalju
        return WeatherConditionInfo(
          description: 'Bersalju',
          icon: Icons.ac_unit_rounded,
          primaryColor: AppTheme.sunBeam,
          gradientColors: const [
            AppTheme.windstorm,
            Color(0xFF90B9DA),
          ],
        );
      case 80:
      case 81:
      case 82: // Hujan Lokal
        return WeatherConditionInfo(
          description: 'Hujan Lokal / Hujan Petir',
          icon: Icons.cloud_sync_rounded,
          primaryColor: AppTheme.sunBeam,
          gradientColors: const [
            Color(0xFF142C42),
            AppTheme.windstorm,
          ],
        );
      case 95:
      case 96:
      case 99: // Badai Petir
        return WeatherConditionInfo(
          description: 'Badai Petir',
          icon: Icons.bolt_rounded,
          primaryColor: AppTheme.sunBeam,
          gradientColors: const [
            AppTheme.blackPine,
            AppTheme.deepOcean,
          ],
        );
      default:
        return WeatherConditionInfo(
          description: 'Cerah Berawan',
          icon: Icons.wb_sunny_rounded,
          primaryColor: AppTheme.sunBeam,
          gradientColors: const [
            AppTheme.deepOcean,
            AppTheme.windstorm,
          ],
        );
    }
  }

  /// Format tanggal singkat bahasa Indonesia (cth: "Hari Ini", "Besok", "Senin, 25 Nov")
  static String formatDayName(String dateStr, int index) {
    if (index == 0) return 'Hari Ini';
    if (index == 1) return 'Besok';

    try {
      final date = DateTime.parse(dateStr);
      final days = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'
      ];
      final dayName = days[date.weekday % 7];
      return '$dayName, ${date.day} ${months[date.month - 1]}';
    } catch (_) {
      return dateStr;
    }
  }
}
