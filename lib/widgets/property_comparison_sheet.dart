import 'package:flutter/material.dart';
import '../models/property_model.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../pages/property_detail_screen.dart';

class PropertyComparisonSheet extends StatelessWidget {
  const PropertyComparisonSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const PropertyComparisonSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final compareProperties = appState.compareProperties;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppTheme.darkCardBg : Colors.white;
    final textPrimary = isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary;
    final textSecondary = isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary;
    final border = isDark ? AppTheme.darkBorder : AppTheme.borderLight;

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle & Top Bar
          Padding(
            padding: const EdgeInsets.only(top: 14, left: 20, right: 20, bottom: 10),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.compare_arrows_rounded, color: AppTheme.primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          'Property Comparison',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textPrimary,
                          ),
                        ),
                      ],
                    ),
                    if (compareProperties.isNotEmpty)
                      TextButton(
                        onPressed: () => appState.clearCompare(),
                        child: const Text('Clear All', style: TextStyle(color: AppTheme.error)),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Main Comparison Content
          Expanded(
            child: compareProperties.isEmpty
                ? _buildEmptyState(context, appState, textPrimary, textSecondary)
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Property Header Columns (Cards)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: compareProperties.map((p) {
                              return Container(
                                width: 170,
                                margin: const EdgeInsets.only(right: 12),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: border),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: SizedBox(
                                            height: 100,
                                            width: double.infinity,
                                            child: p.images.isNotEmpty
                                                ? (p.images.first.startsWith('assets/')
                                                    ? Image.asset(p.images.first, fit: BoxFit.cover)
                                                    : Image.network(p.images.first, fit: BoxFit.cover))
                                                : Container(color: Colors.grey),
                                          ),
                                        ),
                                        Positioned(
                                          top: 4,
                                          right: 4,
                                          child: CircleAvatar(
                                            radius: 12,
                                            backgroundColor: Colors.black.withValues(alpha: 0.6),
                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              icon: const Icon(Icons.close, size: 14, color: Colors.white),
                                              onPressed: () => appState.toggleCompare(p.id),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      p.formattedPrice + p.priceSuffix,
                                      style: const TextStyle(
                                        color: AppTheme.primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      p.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 32,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          textStyle: const TextStyle(fontSize: 11),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (ctx) => PropertyDetailScreen(property: p),
                                            ),
                                          );
                                        },
                                        child: const Text('View'),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Metric Rows
                        _buildSectionHeader('Core Specifications', textPrimary),
                        _buildComparisonRow(
                          'Price / SqFt',
                          compareProperties.map((p) => '\$${p.pricePerSqft.toStringAsFixed(0)}').toList(),
                          textPrimary,
                          border,
                        ),
                        _buildComparisonRow(
                          'Bedrooms',
                          compareProperties.map((p) => '${p.bedrooms} Beds').toList(),
                          textPrimary,
                          border,
                        ),
                        _buildComparisonRow(
                          'Bathrooms',
                          compareProperties.map((p) => '${p.bathrooms} Baths').toList(),
                          textPrimary,
                          border,
                        ),
                        _buildComparisonRow(
                          'Living Area',
                          compareProperties.map((p) => '${p.areaSqft.toInt()} sqft').toList(),
                          textPrimary,
                          border,
                        ),
                        _buildComparisonRow(
                          'Parking',
                          compareProperties.map((p) => '${p.parkingSpaces} spaces').toList(),
                          textPrimary,
                          border,
                        ),
                        _buildComparisonRow(
                          'Year Built',
                          compareProperties.map((p) => '${p.yearBuilt}').toList(),
                          textPrimary,
                          border,
                        ),
                        _buildComparisonRow(
                          'Property Type',
                          compareProperties.map((p) => p.type.displayName).toList(),
                          textPrimary,
                          border,
                        ),
                        _buildComparisonRow(
                          'Rating',
                          compareProperties.map((p) => '⭐ ${p.rating} (${p.reviewsCount})').toList(),
                          textPrimary,
                          border,
                        ),

                        const SizedBox(height: 20),
                        _buildSectionHeader('Features & Amenities', textPrimary),
                        ...['Swimming Pool', 'Private Garden', 'Smart Security', 'EV Charging Station', 'Private Elevator', 'High-Speed Wi-Fi'].map((amenity) {
                          return _buildAmenityCheckRow(
                            amenity,
                            compareProperties.map((p) => p.amenities.any((a) => a.toLowerCase().contains(amenity.toLowerCase()))).toList(),
                            textPrimary,
                            border,
                          );
                        }),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color textPrimary) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildComparisonRow(String metric, List<String> values, Color textPrimary, Color border) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: border)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              metric,
              style: TextStyle(fontSize: 12.5, color: textPrimary.withValues(alpha: 0.7)),
            ),
          ),
          Expanded(
            child: Row(
              children: values.map((val) {
                return Expanded(
                  child: Text(
                    val,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityCheckRow(String amenity, List<bool> hasAmenity, Color textPrimary, Color border) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: border)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              amenity,
              style: TextStyle(fontSize: 12.5, color: textPrimary.withValues(alpha: 0.7)),
            ),
          ),
          Expanded(
            child: Row(
              children: hasAmenity.map((has) {
                return Expanded(
                  child: Center(
                    child: Icon(
                      has ? Icons.check_circle_rounded : Icons.cancel_outlined,
                      size: 18,
                      color: has ? AppTheme.primaryColor : Colors.grey.shade400,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppState appState, Color textPrimary, Color textSecondary) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppTheme.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.compare_arrows_rounded, color: AppTheme.primaryColor, size: 48),
            ),
            const SizedBox(height: 18),
            Text(
              'No Properties Added to Compare',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the "Compare" button on any property card or detail screen to compare up to 3 listings side-by-side.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: textSecondary, height: 1.4),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Pre-add first two properties for immediate exploration
                if (appState.properties.isNotEmpty) {
                  appState.toggleCompare(appState.properties[0].id);
                  if (appState.properties.length > 1) {
                    appState.toggleCompare(appState.properties[1].id);
                  }
                }
              },
              child: const Text('Add Top 2 Properties to Compare'),
            ),
          ],
        ),
      ),
    );
  }
}
