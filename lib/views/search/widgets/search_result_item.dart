import 'package:flutter/material.dart';
import '../../../models/location_model.dart';

class SearchResultItem extends StatelessWidget {
  final LocationModel location;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;
  final VoidCallback? onDelete;

  const SearchResultItem({
    super.key,
    required this.location,
    required this.isFavorite,
    required this.onTap,
    required this.onToggleFavorite,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1E88E5).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.location_city_rounded,
            color: Color(0xFF1E88E5),
            size: 22,
          ),
        ),
        title: Text(
          location.name,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1F36),
          ),
        ),
        subtitle: Text(
          location.subtitle.isEmpty
              ? 'Lat: ${location.latitude.toStringAsFixed(2)}, Lon: ${location.longitude.toStringAsFixed(2)}'
              : location.subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: isFavorite ? 'Hapus dari favorit' : 'Tambah ke favorit',
              icon: Icon(
                isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                color: isFavorite ? Colors.amber.shade700 : const Color(0xFF9E9E9E),
                size: 24,
              ),
              onPressed: onToggleFavorite,
            ),
            if (onDelete != null)
              IconButton(
                tooltip: 'Hapus dari riwayat',
                icon: const Icon(
                  Icons.close_rounded,
                  color: Color(0xFF9E9E9E),
                  size: 20,
                ),
                onPressed: onDelete,
              ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
