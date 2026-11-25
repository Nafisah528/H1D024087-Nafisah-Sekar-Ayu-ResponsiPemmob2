import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_theme.dart';
import '../../viewmodels/weather_viewmodel.dart';
import '../search/search_screen.dart';
import 'widgets/current_weather_card.dart';
import 'widgets/daily_forecast_list.dart';
import 'widgets/weather_details_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Inisialisasi data cuaca setelah frame pertama dirender
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final weatherVM = Provider.of<WeatherViewModel>(context, listen: false);
      if (weatherVM.weatherData == null) {
        weatherVM.initialize();
      } else {
        weatherVM.checkFavoriteStatus();
      }
    });
  }

  void _navigateToSearch() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SearchScreen()),
    );
    // Sinkronisasi status favorit setelah kembali dari search screen
    if (!mounted) return;
    Provider.of<WeatherViewModel>(context, listen: false).checkFavoriteStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.avalanche,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Consumer<WeatherViewModel>(
          builder: (context, vm, child) {
            return Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.deepOcean,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.wb_cloudy_rounded,
                    color: AppTheme.sunBeam,
                    size: 19,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    vm.currentLocation?.name ?? 'Cuaca Terkini',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.blackPine,
                      letterSpacing: -0.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          // Tombol Bookmark / Favorit
          Consumer<WeatherViewModel>(
            builder: (context, vm, child) {
              if (vm.currentLocation == null) return const SizedBox.shrink();
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.cardSurface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.windstorm.withValues(alpha: 0.4),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                  tooltip: vm.isCurrentFavorite
                      ? 'Hapus dari favorit'
                      : 'Simpan ke favorit',
                  icon: Icon(
                    vm.isCurrentFavorite
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: vm.isCurrentFavorite
                        ? const Color(0xFFD48B16)
                        : AppTheme.deepOcean,
                    size: 22,
                  ),
                  onPressed: () async {
                    await vm.toggleCurrentFavorite();
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppTheme.blackPine,
                        content: Text(
                          vm.isCurrentFavorite
                              ? 'Lokasi ${vm.currentLocation!.name} ditambahkan ke favorit'
                              : 'Lokasi ${vm.currentLocation!.name} dihapus dari favorit',
                          style: const TextStyle(
                            color: AppTheme.sunBeam,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),

          // Tombol Search
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.cardSurface,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.windstorm.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              tooltip: 'Cari Lokasi Lain',
              icon: const Icon(
                Icons.search_rounded,
                color: AppTheme.deepOcean,
                size: 22,
              ),
              onPressed: _navigateToSearch,
            ),
          ),

          // Tombol Refresh
          Consumer<WeatherViewModel>(
            builder: (context, vm, child) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.cardSurface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.windstorm.withValues(alpha: 0.4),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                  tooltip: 'Segarkan data cuaca',
                  icon: const Icon(
                    Icons.refresh_rounded,
                    color: AppTheme.deepOcean,
                    size: 22,
                  ),
                  onPressed: vm.isLoading ? null : () => vm.refreshWeather(),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<WeatherViewModel>(
        builder: (context, vm, child) {
          // 1. Kondisi Loading Pertama Kali
          if (vm.isLoading && vm.weatherData == null) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.deepOcean),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Mengambil informasi cuaca...',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.deepOcean,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }

          // 2. Kondisi Error Permintaan API Gagal
          if (vm.errorMessage != null && vm.weatherData == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppTheme.cardSurface,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.red.shade300, width: 1.5),
                      ),
                      child: Icon(
                        Icons.cloud_off_rounded,
                        color: Colors.red.shade400,
                        size: 54,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Gagal Memuat Cuaca',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.blackPine,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      vm.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.deepOcean,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.deepOcean,
                        foregroundColor: AppTheme.sunBeam,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () => vm.refreshWeather(),
                      icon: const Icon(Icons.refresh_rounded, size: 20),
                      label: const Text(
                        'Coba Lagi',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // 3. Kondisi Data Kosong (Edge Case)
          if (vm.weatherData == null || vm.currentLocation == null) {
            return const Center(
              child: Text(
                'Tidak ada data cuaca yang dapat ditampilkan.',
                style: TextStyle(color: AppTheme.deepOcean),
              ),
            );
          }

          // 4. Kondisi Sukses Menampilkan Data
          final weather = vm.weatherData!;
          final today = weather.daily.isNotEmpty ? weather.daily.first : null;

          return RefreshIndicator(
            color: AppTheme.deepOcean,
            backgroundColor: AppTheme.cardSurface,
            onRefresh: () => vm.refreshWeather(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 680),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Indikator loading saat refresh di background
                      if (vm.isLoading)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: LinearProgressIndicator(
                            minHeight: 3,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.deepOcean),
                          ),
                        ),

                      // Card Cuaca Saat Ini
                      CurrentWeatherCard(
                        location: vm.currentLocation!,
                        current: weather.current,
                        todayForecast: today,
                      ),
                      const SizedBox(height: 20),

                      // Grid Rincian Cuaca Tambahan
                      WeatherDetailsGrid(
                        current: weather.current,
                        todayForecast: today,
                      ),
                      const SizedBox(height: 24),

                      // Perkiraan Cuaca Harian
                      DailyForecastList(
                        dailyForecasts: weather.daily,
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.deepOcean,
        foregroundColor: AppTheme.sunBeam,
        elevation: 5,
        icon: const Icon(Icons.search_rounded),
        label: const Text(
          'Cari Kota',
          style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.3),
        ),
        onPressed: _navigateToSearch,
      ),
    );
  }
}
