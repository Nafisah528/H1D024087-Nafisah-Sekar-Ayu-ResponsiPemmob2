# Aplikasi Cuaca Flutter (Responsi Flutter)

Aplikasi informasi perkiraan cuaca modern berbasis Flutter dengan pola arsitektur **Model-View-ViewModel (MVVM)**, integrasi **REST API Open-Meteo**, pengelolaan state reaktif dengan **Provider**, serta penyimpanan lokal (**Local Storage**) menggunakan **SharedPreferences**.

---

## Daftar Isi
- [Fitur Utama](#fitur-utama)
- [Struktur Arsitektur MVVM](#struktur-arsitektur-mvvm)
- [Struktur Direktori Proyek](#struktur-direktori-proyek)
- [Implementasi REST API Open-Meteo](#implementasi-rest-api-open-meteo)
- [Penyimpanan Lokal (Local Storage)](#penyimpanan-lokal-local-storage)
- [Pengelolaan State & Recomposition](#pengelolaan-state--recomposition)
- [Tampilan Layar (Screenshots)](#tampilan-layar-screenshots)
- [Panduan Menjalankan Aplikasi](#panduan-menjalankan-aplikasi)
- [Pengujian (Testing)](#pengujian-testing)

---

## Fitur Utama

1. **Home / Weather Screen**:
   - Menampilkan nama kota yang sedang dipilih beserta wilayah/provinsi dan negara.
   - Menampilkan kondisi cuaca terkini (dilengkapi ikon cuaca dan warna aksen dinamis).
   - Menampilkan suhu saat ini (`current.temperature_2m`).
   - Menampilkan informasi tambahan cuaca:
     - Kelembapan udara (`current.relative_humidity_2m`)
     - Kecepatan angin (`current.wind_speed_10m`)
     - Kemungkinan/peluang hujan (`daily.precipitation_probability_max`)
     - Curah hujan (`current.precipitation`)
     - Suhu yang dirasakan / Apparent Temperature (`current.apparent_temperature`)
   - Menampilkan perkiraan cuaca 7 hari ke depan dengan rentang suhu min-max harian.
   - Fitur bookmark / simpan kota aktif ke daftar favorit secara langsung (ikon bintang).
   - Fitur *Pull-to-Refresh* untuk memperbarui data cuaca terkini dari API.

2. **Search / Location Screen**:
   - Kolom pencarian interaktif untuk mencari nama kota di seluruh dunia.
   - Melakukan request langsung ke **Open-Meteo Geocoding API**.
   - Menampilkan daftar hasil pencarian kota secara detail (nama, provinsi, negara, koordinat).
   - Memungkinkan pengguna memilih lokasi untuk langsung menampilkan informasi cuacanya di Home Screen.
   - Tab **Favorit**: Menampilkan daftar kota favorit yang tersimpan di penyimpanan lokal.
   - Tab **Riwayat Pencarian**: Menampilkan daftar riwayat kota yang pernah dipilih sebelumnya, lengkap dengan opsi hapus per item dan hapus semua riwayat.

3. **User Experience & Error Handling**:
   - Menangani kondisi loading dengan indikator animasi yang jelas.
   - Menangani kondisi koneksi error / API failure dengan tombol *Coba Lagi* (*Retry*).
   - Menangani kondisi data kosong / kota tidak ditemukan (*Empty State*).
   - Desain responsif berbasis Material Design 3 dengan palet warna dan tipografi yang konsisten.

---

## Struktur Arsitektur MVVM

Aplikasi ini menerapkan pola arsitektur **Model-View-ViewModel (MVVM)** untuk memisahkan logika bisnis, pemrosesan data, dan antarmuka pengguna:

```
┌────────────────────────────────────────────────────────┐
│                        VIEW                            │
│  - HomeScreen & Widgets (CurrentCard, Details, Daily)  │
│  - SearchScreen & Widgets (SearchResultItem, Tabs)     │
└──────────────────────────▲─────────────────────────────┘
                           │ Data Binding & Notifikasi
                           │ (via Provider / ChangeNotifier)
┌──────────────────────────▼─────────────────────────────┐
│                      VIEWMODEL                         │
│  - WeatherViewModel: State cuaca, lokasi, status fav   │
│  - SearchViewModel: State pencarian, history, favorit  │
└──────────────────────────▲─────────────────────────────┘
                           │ Memanggil Services
                           │ Menerima Data Model
┌──────────────────────────▼─────────────────────────────┐
│                        MODEL                           │
│  - WeatherModel & CurrentWeather & DailyForecast       │
│  - LocationModel (Geo data & coordinates)              │
│  ────────────────────────────────────────────────────  │
│                       SERVICES                         │
│  - WeatherApiService (Open-Meteo HTTP REST GET)        │
│  - LocalStorageService (SharedPreferences)             │
└────────────────────────────────────────────────────────┘
```

- **Model**: Merepresentasikan entitas data (`WeatherModel`, `CurrentWeather`, `DailyForecast`, `LocationModel`) yang dilengkapi konversi dari dan ke JSON.
- **Services**: Menangani komunikasi jaringan ke Open-Meteo API dan persistensi ke penyimpanan lokal SharedPreferences.
- **ViewModel**: Mengatur logika bisnis dan state aplikasi menggunakan `ChangeNotifier`. ViewModel meminta data dari service dan memberi tahu View saat state berubah melalui `notifyListeners()`.
- **View**: Menampilkan UI berbasis Flutter widgets (StatelessWidget dan StatefulWidget) yang mendengarkan perubahan data dari ViewModel menggunakan `Consumer` atau `Provider.of`.

---

## Struktur Direktori Proyek

```
lib/
├── main.dart                               # Entry point, MultiProvider, MaterialApp & tema
├── models/
│   ├── location_model.dart                 # Model data lokasi kota & koordinat
│   └── weather_model.dart                  # Model cuaca terkini & prakiraan harian
├── services/
│   ├── local_storage_service.dart          # Layanan SharedPreferences (favorit, riwayat, lokasi terakhir)
│   └── weather_api_service.dart            # Layanan REST API Open-Meteo (Forecast & Geocoding)
├── utils/
│   ├── app_theme.dart                      # Definisi Material 3 Theme, ColorScheme & Tipografi
│   └── weather_utils.dart                  # Mapping WMO Weather Code ke deskripsi, ikon & warna
├── viewmodels/
│   ├── search_viewmodel.dart               # ViewModel pencarian, riwayat, dan favorit
│   └── weather_viewmodel.dart              # ViewModel cuaca, inisialisasi, dan refresh
└── views/
    ├── home/
    │   ├── home_screen.dart                # Layar utama (Weather Screen)
    │   └── widgets/
    │       ├── current_weather_card.dart   # Card hero cuaca terkini & suhu utama
    │       ├── daily_forecast_list.dart    # Daftar perkiraan cuaca 7 hari
    │       └── weather_details_grid.dart   # Grid detail: kelembapan, angin, hujan, presipitasi
    └── search/
        ├── search_screen.dart              # Layar pencarian lokasi, favorit & riwayat
        └── widgets/
            └── search_result_item.dart     # Komponen item list hasil pencarian / favorit
```

---

## Implementasi REST API Open-Meteo

Aplikasi mengintegrasikan dua endpoint resmi dari [Open-Meteo](https://open-meteo.com/):

### 1. Weather Forecast API
Mengambil kondisi cuaca terkini dan perkiraan beberapa hari ke depan menggunakan metode HTTP `GET`.
- **Endpoint**: `https://api.open-meteo.com/v1/forecast`
- **Parameter yang digunakan**:
  - `latitude`: Koordinat lintang lokasi (cth: `-6.2146`)
  - `longitude`: Koordinat bujur lokasi (cth: `106.8451`)
  - `current`: `temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m`
  - `daily`: `weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max`
  - `timezone`: `auto`

### 2. Geocoding API
Mencari kota di dunia secara langsung berdasarkan nama lokasi yang diketikkan pengguna.
- **Endpoint**: `https://geocoding-api.open-meteo.com/v1/search`
- **Parameter yang digunakan**:
  - `name`: Kata kunci nama kota (cth: `Bandung`)
  - `count`: `10`
  - `language`: `id`
  - `format`: `json`

### Pemetaan Kode Cuaca WMO (WMO Weather Code)
Kode kondisi cuaca dikonversi ke bahasa Indonesia yang ramah pengguna dan ikon Material yang relevan:
- `0`: Cerah (`Icons.wb_sunny_rounded`)
- `1 - 3`: Cerah Berawan / Sebagian Berawan / Mendung
- `45, 48`: Berkabut
- `51 - 55`: Gerimis Ringan / Sedang / Lebat
- `61 - 65`: Hujan Ringan / Sedang / Lebat
- `80 - 82`: Hujan Lokal / Shower
- `95 - 99`: Badai Petir (`Icons.bolt_rounded`)

---

## Penyimpanan Lokal (Local Storage)

Menggunakan package **`shared_preferences`** untuk menyimpan data secara persisten di perangkat:

1. **Lokasi Terakhir (`last_selected_location`)**:
   - Menyimpan kota yang terakhir kali dilihat pengguna.
   - Saat aplikasi ditutup dan dibuka kembali, aplikasi secara otomatis menampilkan data cuaca kota terakhir tersebut.
2. **Lokasi Favorit (`favorite_locations`)**:
   - Menyimpan daftar kota favorit dalam format JSON string.
   - Memastikan tidak ada duplikasi kota.
   - Dapat ditambah/dihapus dari Home Screen maupun Search Screen.
3. **Riwayat Pencarian (`search_history`)**:
   - Menyimpan riwayat kota yang dipilih pengguna (maksimal 15 kota terbaru).
   - Pengguna dapat menghapus riwayat satu per satu atau mengosongkan seluruh riwayat sekaligus.

---

## Pengelolaan State & Recomposition

- Menggunakan **`provider`** dengan pendekatan `ChangeNotifier`.
- `WeatherViewModel` dan `SearchViewModel` didaftarkan secara global pada root widget (`MultiProvider` di `main.dart`).
- Layar UI menggunakan widget `Consumer<WeatherViewModel>` dan `Consumer<SearchViewModel>` sehingga hanya bagian antarmuka yang relevan yang di-rebuild (efisiensi recomposition).

---

## Tampilan Layar (Screenshots)

| 1. Home / Weather Screen | 2. Search Screen (Pencarian) | 3. Search Screen (Favorit & Riwayat) |
| :---: | :---: | :---: |
| ![Home Weather Screen](screenshots/screen_home.png) | ![Search API Results](screenshots/screen_search_results.png) | ![Favorites and History](screenshots/screen_favorites_history.png) |

> *Catatan: Letakkan file tangkapan layar aplikasi ke dalam direktori `screenshots/` sesuai penamaan di atas sebelum pengumpulan.*

---

## Panduan Menjalankan Aplikasi

### Prasyarat
- Flutter SDK (versi >= 3.13.0)
- Dart SDK (versi >= 3.13.0)
- Emulator Android / iOS / Perangkat Fisik / Windows Desktop / Browser Chrome

### Langkah-langkah:
1. **Clone repository**:
   ```bash
   git clone <URL_REPOSITORY_ANDA>
   cd responsi2
   ```

2. **Unduh seluruh dependensi**:
   ```bash
   flutter pub get
   ```

3. **Jalankan aplikasi**:
   - Pada perangkat/emulator yang terhubung:
     ```bash
     flutter run
     ```
   - Atau jalankan pada browser Chrome:
     ```bash
     flutter run -d chrome
     ```
   - Atau jalankan pada Windows Desktop:
     ```bash
     flutter run -d windows
     ```

---

## Pengujian (Testing)

Proyek ini telah dilengkapi dengan unit test untuk memvalidasi model serialisasi, parsing payload API Open-Meteo, dan utilitas cuaca:

```bash
flutter test
```

Jalankan juga analisis kode statis untuk memastikan kode bersih dari kesalahan maupun peringatan:

```bash
flutter analyze
```

---

## Ketentuan Pengumpulan
- **Link Pengumpulan**: [Google Forms](https://forms.gle/vz5LUdPVZmJ2F5uKA)
- **Batas Pengerjaan**: 26 November 2026, Pukul 10:00 Pagi WIB
