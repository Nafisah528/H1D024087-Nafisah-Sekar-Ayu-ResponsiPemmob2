import 'package:flutter/material.dart';
import '../../../models/location_model.dart';
import '../../../models/weather_model.dart';
import '../../../utils/app_theme.dart';
import '../../../utils/weather_utils.dart';

class CurrentWeatherCard extends StatelessWidget {
  final LocationModel location;
  final CurrentWeather current;
  final DailyForecast? todayForecast;

  const CurrentWeatherCard({
    super.key,
    required this.location,
    required this.current,
    this.todayForecast,
  });

  @override
  Widget build(BuildContext context) {
    final condition = WeatherUtils.getCondition(current.weatherCode);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: condition.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.deepOcean.withValues(alpha: 0.25),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background decorative weather icon
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              condition.icon,
              size: 190,
              color: Colors.white.withValues(alpha: 0.12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Lokasi Chip
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      color: AppTheme.sunBeam,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        location.fullDisplayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Icon Cuaca & Kondisi
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.meltingIce.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        condition.icon,
                        color: condition.primaryColor,
                        size: 34,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        condition.description,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Suhu Utama
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      current.temperature.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 64,
                        fontWeight: FontWeight.w800,
                        height: 1.0,
                        letterSpacing: -2,
                      ),
                    ),
                    const Text(
                      '°C',
                      style: TextStyle(
                        color: AppTheme.sunBeam,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Info Suhu Terasa & Rentang Harian
                Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  children: [
                    _buildPill(
                      icon: Icons.thermostat_rounded,
                      label: 'Terasa ${current.apparentTemperature.toStringAsFixed(1)}°C',
                    ),
                    if (todayForecast != null)
                      _buildPill(
                        icon: Icons.swap_vert_rounded,
                        label: '${todayForecast!.tempMin.toStringAsFixed(0)}° - ${todayForecast!.tempMax.toStringAsFixed(0)}°C',
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPill({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.meltingIce.withValues(alpha: 0.25),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppTheme.sunBeam, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
