import 'dart:convert';

class LocationModel {
  final int? id;
  final String name;
  final double latitude;
  final double longitude;
  final String? country;
  final String? admin1;
  final String? timezone;

  LocationModel({
    this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.country,
    this.admin1,
    this.timezone,
  });

  /// Nama lengkap yang informatif, misalnya "Bandung, Jawa Barat, Indonesia"
  String get fullDisplayName {
    final parts = <String>[name];
    if (admin1 != null && admin1!.isNotEmpty && admin1 != name) {
      parts.add(admin1!);
    }
    if (country != null && country!.isNotEmpty) {
      parts.add(country!);
    }
    return parts.join(', ');
  }

  /// Subtitle singkat untuk tampilan list
  String get subtitle {
    final parts = <String>[];
    if (admin1 != null && admin1!.isNotEmpty && admin1 != name) {
      parts.add(admin1!);
    }
    if (country != null && country!.isNotEmpty) {
      parts.add(country!);
    }
    return parts.join(', ');
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] is int ? json['id'] as int : null,
      name: json['name'] as String? ?? 'Tidak Diketahui',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      country: json['country'] as String?,
      admin1: json['admin1'] as String?,
      timezone: json['timezone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'country': country,
      'admin1': admin1,
      'timezone': timezone,
    };
  }

  String toJsonString() => jsonEncode(toJson());

  factory LocationModel.fromJsonString(String source) =>
      LocationModel.fromJson(jsonDecode(source) as Map<String, dynamic>);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationModel &&
        other.name == name &&
        (other.latitude - latitude).abs() < 0.001 &&
        (other.longitude - longitude).abs() < 0.001;
  }

  @override
  int get hashCode => Object.hash(name, latitude.toStringAsFixed(3), longitude.toStringAsFixed(3));
}
