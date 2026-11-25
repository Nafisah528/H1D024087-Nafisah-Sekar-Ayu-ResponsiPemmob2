import 'package:flutter/material.dart';
import '../../../models/weather_model.dart';
import '../../../utils/app_theme.dart';

class WeatherDetailsGrid extends StatelessWidget {
  final CurrentWeather current;
  final DailyForecast? todayForecast;

  const WeatherDetailsGrid({
    super.key,
    required this.current,
    this.todayForecast,
  });

  @override
  Widget build(BuildContext context) {
    final rainProb = todayForecast?.precipitationProbabilityMax ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detail Cuaca',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.blackPine,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildDetailCard(
                icon: Icons.water_drop_rounded,
                iconColor: AppTheme.windstorm,
                iconBgColor: AppTheme.meltingIce.withValues(alpha: 0.4),
                title: 'Kelembapan',
                value: '${current.relativeHumidity}%',
                subtitle: 'Udara lembap',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDetailCard(
                icon: Icons.air_rounded,
                iconColor: AppTheme.deepOcean,
                iconBgColor: AppTheme.avalanche,
                title: 'Kecepatan Angin',
                value: '${current.windSpeed.toStringAsFixed(1)} km/h',
                subtitle: 'Angin sepoi',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildDetailCard(
                icon: Icons.umbrella_rounded,
                iconColor: AppTheme.windstorm,
                iconBgColor: AppTheme.meltingIce.withValues(alpha: 0.4),
                title: 'Peluang Hujan',
                value: '$rainProb%',
                subtitle: 'Kemungkinan presipitasi',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDetailCard(
                icon: Icons.grain_rounded,
                iconColor: AppTheme.deepOcean,
                iconBgColor: AppTheme.avalanche,
                title: 'Curah Hujan',
                value: '${current.precipitation.toStringAsFixed(1)} mm',
                subtitle: 'Akumulasi saat ini',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.meltingIce.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.deepOcean.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.blackPine,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.textMuted.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
