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
                fontWeight: FontWeight.w500,
                color: AppTheme.textMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
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
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dailyForecasts.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: AppTheme.meltingIce.withValues(alpha: 0.45),
              indent: 16,
              endIndent: 16,
            ),
            itemBuilder: (context, index) {
              final item = dailyForecasts[index];
              final condition = WeatherUtils.getCondition(item.weatherCode);
              final dayName = WeatherUtils.formatDayName(item.date, index);

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    // Hari / Tanggal
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dayName,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: index == 0 ? FontWeight.w700 : FontWeight.w600,
                              color: index == 0
                                  ? AppTheme.deepOcean
                                  : AppTheme.blackPine,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            condition.description,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textMuted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // Ikon Cuaca & Peluang Hujan
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Icon(
                            condition.icon,
                            color: AppTheme.windstorm,
                            size: 24,
                          ),
                          const SizedBox(width: 6),
                          if (item.precipitationProbabilityMax > 0)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.umbrella_rounded,
                                  color: AppTheme.deepOcean,
                                  size: 13,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '${item.precipitationProbabilityMax}%',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.deepOcean,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),

                    // Rentang Suhu (Min - Max)
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${item.tempMin.toStringAsFixed(0)}°',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textMuted,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 36,
                            height: 4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              gradient: const LinearGradient(
                                colors: [
                                  AppTheme.meltingIce,
                                  AppTheme.windstorm,
                                  Color(0xFFE5C882),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${item.tempMax.toStringAsFixed(0)}°',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.blackPine,
                            ),
                          ),
                        ],
                      ),
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
