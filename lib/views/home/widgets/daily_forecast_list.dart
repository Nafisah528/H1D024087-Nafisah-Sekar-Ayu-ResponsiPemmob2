import 'package:flutter/material.dart';
import '../../../models/weather_model.dart';
import '../../../utils/app_theme.dart';
import '../../../utils/weather_utils.dart';

class DailyForecastList extends StatelessWidget {
  final List<DailyForecast> dailyForecasts;

  const DailyForecastList({
    super.key,
    required this.dailyForecasts,
  });

  @override
  Widget build(BuildContext context) {
    if (dailyForecasts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Perkiraan Cuaca Harian',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.blackPine,
              ),
            ),
            Text(
              '7 Hari ke Depan',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.deepOcean,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.cardSurface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: AppTheme.windstorm.withValues(alpha: 0.45),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.deepOcean.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dailyForecasts.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: AppTheme.windstorm.withValues(alpha: 0.25),
              indent: 16,
              endIndent: 16,
            ),
            itemBuilder: (context, index) {
              final item = dailyForecasts[index];
              final condition = WeatherUtils.getCondition(item.weatherCode);
              final dayName = WeatherUtils.formatDayName(item.date, index);

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    // 1. Hari & Deskripsi (Fleksibel, otomatis menyesuaikan ruang)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dayName,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: index == 0 ? FontWeight.w800 : FontWeight.w600,
                              color: index == 0
                                  ? AppTheme.deepOcean
                                  : AppTheme.blackPine,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            condition.description,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textMuted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // 2. Ikon Cuaca & Badge Peluang Hujan
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppTheme.meltingIce.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            condition.icon,
                            color: AppTheme.deepOcean,
                            size: 18,
                          ),
                        ),
                        if (item.precipitationProbabilityMax > 0) ...[
                          const SizedBox(width: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.deepOcean,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.umbrella_rounded,
                                  color: AppTheme.sunBeam,
                                  size: 10,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '${item.precipitationProbabilityMax}%',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.sunBeam,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(width: 10),

                    // 3. Rentang Suhu (Min - Max)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${item.tempMin.toStringAsFixed(0)}°',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.deepOcean,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          width: 24,
                          height: 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            gradient: const LinearGradient(
                              colors: [
                                AppTheme.windstorm,
                                AppTheme.deepOcean,
                                Color(0xFFE5C882),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${item.tempMax.toStringAsFixed(0)}°',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.blackPine,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
