import 'package:flutter/material.dart';
import '../../../models/weather_model.dart';
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
                color: Color(0xFF1A1F36),
              ),
            ),
            Text(
              '7 Hari ke Depan',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
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
              color: Colors.grey.withValues(alpha: 0.12),
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
                                  ? const Color(0xFF1E88E5)
                                  : const Color(0xFF1A1F36),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            condition.description,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
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
                            color: condition.primaryColor,
                            size: 24,
                          ),
                          const SizedBox(width: 6),
                          if (item.precipitationProbabilityMax > 0)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.umbrella_rounded,
                                  color: Color(0xFF5C6BC0),
                                  size: 13,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '${item.precipitationProbabilityMax}%',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF5C6BC0),
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
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 36,
                            height: 4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF81D4FA), Color(0xFFFF8A65)],
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${item.tempMax.toStringAsFixed(0)}°',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1F36),
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
