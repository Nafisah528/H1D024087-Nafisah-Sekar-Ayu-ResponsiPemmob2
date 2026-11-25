import 'package:flutter/material.dart';

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
  /// ikon yang sesuai, dan warna aksen.
  static WeatherConditionInfo getCondition(int code) {
    switch (code) {
      case 0:
        return WeatherConditionInfo(
          description: 'Cerah',
          icon: Icons.wb_sunny_rounded,
          primaryColor: Colors.amber.shade700,
          gradientColors: [const Color(0xFFF6D365), const Color(0xFFFDA085)],
        );
      case 1:
        return WeatherConditionInfo(
          description: 'Cerah Berawan',
          icon: Icons.wb_sunny_outlined,
          primaryColor: Colors.orange.shade600,
          gradientColors: [const Color(0xFF4FACFE), const Color(0xFF00F2FE)],
        );
      case 2:
        return WeatherConditionInfo(
          description: 'Sebagian Berawan',
          icon: Icons.cloud_queue_rounded,
          primaryColor: Colors.blueGrey.shade600,
          gradientColors: [const Color(0xFF3A7BD5), const Color(0xFF3A6073)],
        );
      case 3:
        return WeatherConditionInfo(
          description: 'Mendung / Berawan Tebal',
          icon: Icons.cloud_rounded,
          primaryColor: Colors.grey.shade700,
          gradientColors: [const Color(0xFF5D6D7E), const Color(0xFF34495E)],
        );
      case 45:
      case 48:
        return WeatherConditionInfo(
          description: 'Berkabut',
          icon: Icons.blur_on_rounded,
          primaryColor: Colors.blueGrey.shade400,
          gradientColors: [const Color(0xFF757F9A), const Color(0xFFD7DDE8)],
        );
      case 51:
      case 53:
      case 55:
        return WeatherConditionInfo(
          description: 'Gerimis Ringan',
          icon: Icons.grain_rounded,
          primaryColor: Colors.teal.shade600,
          gradientColors: [const Color(0xFF4CA1AF), const Color(0xFF2C3E50)],
        );
      case 61:
        return WeatherConditionInfo(
          description: 'Hujan Ringan',
          icon: Icons.water_drop_rounded,
          primaryColor: Colors.blue.shade600,
          gradientColors: [const Color(0xFF00C6FB), const Color(0xFF005BEA)],
        );
      case 63:
        return WeatherConditionInfo(
          description: 'Hujan Sedang',
          icon: Icons.umbrella_rounded,
          primaryColor: Colors.indigo.shade600,
          gradientColors: [const Color(0xFF2193B0), const Color(0xFF6DD5ED)],
        );
      case 65:
        return WeatherConditionInfo(
          description: 'Hujan Lebat',
          icon: Icons.thunderstorm_rounded,
          primaryColor: Colors.blue.shade900,
          gradientColors: [const Color(0xFF141E30), const Color(0xFF243B55)],
        );
      case 71:
      case 73:
      case 75:
      case 77:
        return WeatherConditionInfo(
          description: 'Bersalju',
          icon: Icons.ac_unit_rounded,
          primaryColor: Colors.cyan.shade600,
          gradientColors: [const Color(0xFFE0EAFC), const Color(0xFFCFDEF3)],
        );
      case 80:
      case 81:
      case 82:
        return WeatherConditionInfo(
          description: 'Hujan Lokal / Hujan Petir',
          icon: Icons.cloud_sync_rounded,
          primaryColor: Colors.deepPurple.shade600,
          gradientColors: [const Color(0xFF3F51B5), const Color(0xFF2196F3)],
        );
      case 95:
      case 96:
      case 99:
        return WeatherConditionInfo(
          description: 'Badai Petir',
          icon: Icons.bolt_rounded,
          primaryColor: Colors.deepOrange.shade800,
          gradientColors: [const Color(0xFF0F2027), const Color(0xFF203A43), const Color(0xFF2C5364)],
        );
      default:
        return WeatherConditionInfo(
          description: 'Cerah Berawan',
          icon: Icons.wb_sunny_rounded,
          primaryColor: Colors.blue.shade600,
          gradientColors: [const Color(0xFF36D1DC), const Color(0xFF5B86E5)],
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
