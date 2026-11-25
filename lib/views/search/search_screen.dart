import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/location_model.dart';
import '../../utils/app_theme.dart';
import '../../viewmodels/search_viewmodel.dart';
import '../../viewmodels/weather_viewmodel.dart';
import 'widgets/search_result_item.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Provider.of<SearchViewModel>(context, listen: false).loadFavoritesAndHistory();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onSelectLocation(LocationModel location) async {
    final searchVM = Provider.of<SearchViewModel>(context, listen: false);
    final weatherVM = Provider.of<WeatherViewModel>(context, listen: false);

    // Catat ke riwayat
    await searchVM.recordSelectedLocation(location);

    // Ambil data cuaca untuk lokasi baru
    await weatherVM.fetchWeatherForLocation(location);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchVM = Provider.of<SearchViewModel>(context);

    return Scaffold(
      backgroundColor: AppTheme.avalanche,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Pencarian Lokasi',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            color: AppTheme.blackPine,
          ),
        ),
        iconTheme: const IconThemeData(color: AppTheme.deepOcean),
      ),
      body: Column(
        children: [
          // Input Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              style: const TextStyle(
                color: AppTheme.blackPine,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppTheme.cardSurface,
                hintText: 'Cari nama kota (cth: Bandung, Surabaya, Tokyo)...',
                hintStyle: TextStyle(
                  color: AppTheme.deepOcean.withValues(alpha: 0.6),
                  fontSize: 14,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppTheme.deepOcean,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, color: AppTheme.deepOcean),
                        onPressed: () {
                          _searchController.clear();
                          searchVM.clearSearch();
                          setState(() {});
                        },
                      )
                    : null,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: AppTheme.windstorm.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: AppTheme.deepOcean,
                    width: 2,
                  ),
                ),
              ),
              onChanged: (value) {
                setState(() {});
                searchVM.search(value);
              },
              onSubmitted: (value) {
                searchVM.search(value);
              },
            ),
          ),

          // Tampilan Konten: Hasil Pencarian ATAU Tab Favorit & Riwayat
          Expanded(
            child: _searchController.text.trim().isNotEmpty
                ? _buildSearchResults(searchVM)
                : _buildTabsSection(searchVM),
          ),
        ],
      ),
    );
  }

  /// Menampilkan hasil pencarian langsung dari Open-Meteo Geocoding API
  Widget _buildSearchResults(SearchViewModel searchVM) {
    if (searchVM.isSearching) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.deepOcean),
            ),
            SizedBox(height: 14),
            Text(
              'Mencari kota di Open-Meteo...',
              style: TextStyle(
                color: AppTheme.deepOcean,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    if (searchVM.searchError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded, color: Colors.red.shade400, size: 48),
              const SizedBox(height: 12),
              const Text(
                'Terjadi Masalah Pencarian',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: AppTheme.blackPine,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                searchVM.searchError!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppTheme.deepOcean, fontSize: 13),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.deepOcean,
                  foregroundColor: AppTheme.sunBeam,
                ),
                onPressed: () => searchVM.search(_searchController.text),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    if (searchVM.searchResults.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_off_rounded, color: AppTheme.deepOcean, size: 54),
              const SizedBox(height: 14),
              const Text(
                'Kota Tidak Ditemukan',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: AppTheme.blackPine,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Tidak ada hasil untuk "${_searchController.text}".\nCoba periksa kembali ejaan nama kota.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppTheme.deepOcean, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      itemCount: searchVM.searchResults.length,
      itemBuilder: (context, index) {
        final loc = searchVM.searchResults[index];
        final isFav = searchVM.isLocationFavorite(loc);

        return SearchResultItem(
          location: loc,
          isFavorite: isFav,
          onTap: () => _onSelectLocation(loc),
          onToggleFavorite: () => searchVM.toggleFavorite(loc),
        );
      },
    );
  }

  /// Menampilkan Tab: "Favorit" dan "Riwayat Pencarian"
  Widget _buildTabsSection(SearchViewModel searchVM) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.cardSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.windstorm.withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          child: TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              color: AppTheme.deepOcean,
              borderRadius: BorderRadius.circular(13),
            ),
            labelColor: AppTheme.sunBeam,
            unselectedLabelColor: AppTheme.deepOcean,
            labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            dividerColor: Colors.transparent,
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star_rounded, size: 18),
                    const SizedBox(width: 6),
                    Text('Favorit (${searchVM.favorites.length})'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.history_rounded, size: 18),
                    const SizedBox(width: 6),
                    Text('Riwayat (${searchVM.searchHistory.length})'),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildFavoritesList(searchVM),
              _buildHistoryList(searchVM),
            ],
          ),
        ),
      ],
    );
  }

  /// Tab 1: Daftar Lokasi Favorit
  Widget _buildFavoritesList(SearchViewModel searchVM) {
    if (searchVM.favorites.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(28.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star_border_rounded, size: 54, color: AppTheme.deepOcean),
              SizedBox(height: 12),
              Text(
                'Belum Ada Lokasi Favorit',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: AppTheme.blackPine,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Cari kota di atas lalu tekan ikon bintang untuk menyimpannya sebagai favorit.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.deepOcean, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      itemCount: searchVM.favorites.length,
      itemBuilder: (context, index) {
        final loc = searchVM.favorites[index];
        return SearchResultItem(
          location: loc,
          isFavorite: true,
          onTap: () => _onSelectLocation(loc),
          onToggleFavorite: () => searchVM.toggleFavorite(loc),
        );
      },
    );
  }

  /// Tab 2: Daftar Riwayat Pencarian
  Widget _buildHistoryList(SearchViewModel searchVM) {
    if (searchVM.searchHistory.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(28.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.history_rounded, size: 54, color: AppTheme.deepOcean),
              SizedBox(height: 12),
              Text(
                'Belum Ada Riwayat',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: AppTheme.blackPine,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Kota yang Anda pilih dari hasil pencarian akan tercatat di sini.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.deepOcean, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Riwayat Terakhir',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: AppTheme.deepOcean,
                ),
              ),
              TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red.shade700,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: const Icon(Icons.delete_sweep_rounded, size: 16),
                label: const Text(
                  'Hapus Semua',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
                onPressed: () => searchVM.clearAllHistory(),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            itemCount: searchVM.searchHistory.length,
            itemBuilder: (context, index) {
              final loc = searchVM.searchHistory[index];
              final isFav = searchVM.isLocationFavorite(loc);

              return SearchResultItem(
                location: loc,
                isFavorite: isFav,
                onTap: () => _onSelectLocation(loc),
                onToggleFavorite: () => searchVM.toggleFavorite(loc),
                onDelete: () => searchVM.removeHistoryItem(loc),
              );
            },
          ),
        ),
      ],
    );
  }
}
