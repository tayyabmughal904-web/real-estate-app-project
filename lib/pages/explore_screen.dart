import 'package:flutter/material.dart';
import '../models/property_model.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'property_detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _searchController = TextEditingController();
  bool _isGridView = false;

  @override
  void initState() {
    super.initState();
    final appState = AppStateScope.of(context);
    _searchController.text = appState.searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showSortModal(BuildContext context) {
    final appState = AppStateScope.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
          top: 16,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(ctx).padding.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Sort Properties',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 14),
            ...PropertySortOption.values.map((opt) {
              final isSelected = appState.sortOption == opt;
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                title: Text(
                  opt.displayName,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimary,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check_circle_rounded, color: AppTheme.primaryColor)
                    : null,
                onTap: () {
                  appState.setSortOption(opt);
                  Navigator.pop(ctx);
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _showFilterModal(BuildContext context) {
    final appState = AppStateScope.of(context);

    // Temporary local filter states for modal
    PropertyType? tempType = appState.selectedTypeFilter;
    bool? tempForRent = appState.filterForRent;
    RangeValues tempPrice = appState.priceRange;
    int tempBedrooms = appState.minBedrooms;
    int tempBathrooms = appState.minBathrooms;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: EdgeInsets.only(
                top: 16,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(modalCtx).padding.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filter Properties',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              tempType = null;
                              tempForRent = null;
                              tempPrice = const RangeValues(0, 3000000);
                              tempBedrooms = 0;
                              tempBathrooms = 0;
                            });
                          },
                          child: const Text(
                            'Reset',
                            style: TextStyle(
                              color: AppTheme.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Purpose: Rent / Buy
                    const Text('Listing Purpose', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildFilterChip(
                          label: 'All',
                          isSelected: tempForRent == null,
                          onTap: () => setModalState(() => tempForRent = null),
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          label: 'For Rent',
                          isSelected: tempForRent == true,
                          onTap: () => setModalState(() => tempForRent = true),
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          label: 'For Sale',
                          isSelected: tempForRent == false,
                          onTap: () => setModalState(() => tempForRent = false),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Property Type
                    const Text('Property Type', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: PropertyType.values.map((type) {
                        final isSelected = tempType == type;
                        return _buildFilterChip(
                          label: type.displayName,
                          isSelected: isSelected,
                          onTap: () {
                            setModalState(() => tempType = isSelected ? null : type);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18),

                    // Minimum Bedrooms
                    const Text('Bedrooms', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                    const SizedBox(height: 8),
                    Row(
                      children: [0, 1, 2, 3, 4, 5].map((beds) {
                        final isSelected = tempBedrooms == beds;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _buildFilterChip(
                            label: beds == 0 ? 'Any' : '$beds+',
                            isSelected: isSelected,
                            onTap: () => setModalState(() => tempBedrooms = beds),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18),

                    // Minimum Bathrooms
                    const Text('Bathrooms', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                    const SizedBox(height: 8),
                    Row(
                      children: [0, 1, 2, 3, 4].map((baths) {
                        final isSelected = tempBathrooms == baths;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _buildFilterChip(
                            label: baths == 0 ? 'Any' : '$baths+',
                            isSelected: isSelected,
                            onTap: () => setModalState(() => tempBathrooms = baths),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18),

                    // Price Range
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Price Range', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                        Text(
                          '\$${(tempPrice.start / 1000).toInt()}k - \$${(tempPrice.end / 1000).toInt()}k',
                          style: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    RangeSlider(
                      values: tempPrice,
                      min: 0,
                      max: 3000000,
                      divisions: 30,
                      activeColor: AppTheme.primaryColor,
                      inactiveColor: AppTheme.borderLight,
                      onChanged: (vals) => setModalState(() => tempPrice = vals),
                    ),

                    const SizedBox(height: 24),

                    // Apply Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          appState.setTypeFilter(tempType);
                          appState.setFilterForRent(tempForRent);
                          appState.setPriceRange(tempPrice);
                          appState.setMinBedrooms(tempBedrooms);
                          appState.setMinBathrooms(tempBathrooms);
                          Navigator.pop(ctx);
                        },
                        child: const Text('Apply Filters'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  static Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryLight : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.borderLight,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimary,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final results = appState.filteredProperties;

    final hasActiveFilters = appState.selectedTypeFilter != null ||
        appState.filterForRent != null ||
        appState.minBedrooms > 0 ||
        appState.minBathrooms > 0 ||
        appState.priceRange.start > 0 ||
        appState.priceRange.end < 3000000;

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      appBar: AppBar(
        title: const Text('Explore Properties'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort_rounded, color: AppTheme.textPrimary),
            tooltip: 'Sort Options',
            onPressed: () => _showSortModal(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter controls
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.scaffoldBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.borderLight),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) => appState.setSearchQuery(val),
                      decoration: InputDecoration(
                        hintText: 'Search city, neighborhood, type...',
                        prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.textLight),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  appState.setSearchQuery('');
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Filter button
                GestureDetector(
                  onTap: () => _showFilterModal(context),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: hasActiveFilters ? AppTheme.primaryColor : AppTheme.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.primaryColor.withOpacity(hasActiveFilters ? 1 : 0.3),
                      ),
                    ),
                    child: Icon(
                      Icons.tune_rounded,
                      color: hasActiveFilters ? Colors.white : AppTheme.primaryColor,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Count & View Switcher header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      '${results.length} properties found',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    if (appState.sortOption != PropertySortOption.recommended) ...[
                      const SizedBox(width: 6),
                      Text(
                        '(${appState.sortOption.displayName})',
                        style: const TextStyle(fontSize: 12, color: AppTheme.primaryColor, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.view_list_rounded,
                        color: !_isGridView ? AppTheme.primaryColor : AppTheme.textLight,
                      ),
                      onPressed: () => setState(() => _isGridView = false),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.grid_view_rounded,
                        color: _isGridView ? AppTheme.primaryColor : AppTheme.textLight,
                      ),
                      onPressed: () => setState(() => _isGridView = true),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Results list or grid
          Expanded(
            child: results.isEmpty
                ? _buildEmptyState(appState)
                : _isGridView
                    ? _buildGridView(results, appState)
                    : _buildListView(results, appState),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppState appState) {
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
              child: const Icon(
                Icons.search_off_rounded,
                size: 48,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No properties match your filters',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try changing your search terms, price range, or reset filters to see all luxury properties.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _searchController.clear();
                appState.resetFilters();
              },
              child: const Text('Reset All Filters'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(List<Property> properties, AppState appState) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      itemCount: properties.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, idx) {
        final prop = properties[idx];
        final isFav = appState.isFavorite(prop.id);

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => PropertyDetailScreen(property: prop),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.borderLight),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                      child: prop.images.first.startsWith('assets/')
                          ? Image.asset(
                              prop.images.first,
                              height: 155,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              prop.images.first,
                              height: 155,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                height: 155,
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.image_not_supported),
                              ),
                            ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          prop.isForRent ? 'FOR RENT' : 'FOR SALE',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: () => appState.toggleFavorite(prop.id),
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.white.withOpacity(0.9),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border_rounded,
                            color: isFav ? AppTheme.error : AppTheme.textPrimary,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${prop.formattedPrice}${prop.priceSuffix}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, size: 16, color: AppTheme.accentColor),
                              const SizedBox(width: 2),
                              Text(
                                '${prop.rating}',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        prop.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        prop.address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildMiniSpec(Icons.bed_outlined, '${prop.bedrooms} beds'),
                          const SizedBox(width: 12),
                          _buildMiniSpec(Icons.bathtub_outlined, '${prop.bathrooms} baths'),
                          const SizedBox(width: 12),
                          _buildMiniSpec(Icons.square_foot_outlined, '${prop.areaSqft.toInt()} sqft'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridView(List<Property> properties, AppState appState) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: properties.length,
      itemBuilder: (context, idx) {
        final prop = properties[idx];
        final isFav = appState.isFavorite(prop.id);

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => PropertyDetailScreen(property: prop),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: prop.images.first.startsWith('assets/')
                          ? Image.asset(
                              prop.images.first,
                              height: 110,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              prop.images.first,
                              height: 110,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                height: 110,
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.image_not_supported),
                              ),
                            ),
                    ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: GestureDetector(
                        onTap: () => appState.toggleFavorite(prop.id),
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.white.withOpacity(0.9),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border_rounded,
                            color: isFav ? AppTheme.error : AppTheme.textPrimary,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${prop.formattedPrice}${prop.priceSuffix}',
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        prop.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        prop.city,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${prop.bedrooms} beds • ${prop.bathrooms} baths',
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMiniSpec(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppTheme.textLight),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 11.5,
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
