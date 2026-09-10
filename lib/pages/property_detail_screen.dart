import 'package:flutter/material.dart';
import '../models/property_model.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'schedule_tour_sheet.dart';
import 'chat_detail_screen.dart';

class PropertyDetailScreen extends StatefulWidget {
  final Property property;

  const PropertyDetailScreen({super.key, required this.property});

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  int _currentImageIndex = 0;
  bool _isDescriptionExpanded = false;

  IconData _getAmenityIcon(String amenity) {
    final lower = amenity.toLowerCase();
    if (lower.contains('pool')) return Icons.pool_rounded;
    if (lower.contains('wi-fi') || lower.contains('internet')) return Icons.wifi_rounded;
    if (lower.contains('garage') || lower.contains('parking')) return Icons.directions_car_rounded;
    if (lower.contains('security') || lower.contains('cameras')) return Icons.security_rounded;
    if (lower.contains('ac') || lower.contains('climate') || lower.contains('heating')) {
      return Icons.ac_unit_rounded;
    }
    if (lower.contains('garden') || lower.contains('courtyard')) return Icons.park_rounded;
    if (lower.contains('balcony') || lower.contains('terrace')) return Icons.balcony_rounded;
    if (lower.contains('ev') || lower.contains('solar')) return Icons.electric_bolt_rounded;
    if (lower.contains('gym') || lower.contains('fitness') || lower.contains('spa')) {
      return Icons.fitness_center_rounded;
    }
    if (lower.contains('elevator')) return Icons.elevator_rounded;
    if (lower.contains('waterfront') || lower.contains('ocean')) return Icons.water_rounded;
    return Icons.check_circle_outline_rounded;
  }

  IconData _getNeighborhoodIcon(String category) {
    switch (category.toLowerCase()) {
      case 'metro':
        return Icons.train_rounded;
      case 'school':
        return Icons.school_rounded;
      case 'hospital':
        return Icons.local_hospital_rounded;
      case 'mall':
        return Icons.shopping_bag_rounded;
      case 'airport':
        return Icons.flight_rounded;
      case 'beach':
        return Icons.beach_access_rounded;
      default:
        return Icons.place_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final isFav = appState.isFavorite(widget.property.id);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main Scrollable Content
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Carousel
                _buildImageCarousel(),

                // Property Info Container
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge & Rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.property.isForRent ? 'FOR RENT' : 'FOR SALE',
                              style: const TextStyle(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, color: AppTheme.accentColor, size: 20),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.property.rating}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              Text(
                                ' (${widget.property.reviewsCount} reviews)',
                                style: const TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Title
                      Text(
                        widget.property.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                          height: 1.25,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Address
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 18,
                            color: AppTheme.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${widget.property.address}, ${widget.property.city}',
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 13.5,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Specs Grid Row
                      _buildSpecRow(),

                      const SizedBox(height: 24),
                      const Divider(height: 1, color: AppTheme.borderLight),
                      const SizedBox(height: 20),

                      // Agent Card
                      _buildAgentCard(appState),

                      const SizedBox(height: 24),
                      const Divider(height: 1, color: AppTheme.borderLight),
                      const SizedBox(height: 20),

                      // Description
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.property.description,
                        maxLines: _isDescriptionExpanded ? null : 3,
                        overflow: _isDescriptionExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13.5,
                          color: AppTheme.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () => setState(() => _isDescriptionExpanded = !_isDescriptionExpanded),
                        child: Text(
                          _isDescriptionExpanded ? 'Read Less' : 'Read More',
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                      const Divider(height: 1, color: AppTheme.borderLight),
                      const SizedBox(height: 20),

                      // Amenities
                      const Text(
                        'Features & Amenities',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _buildAmenitiesGrid(),

                      const SizedBox(height: 24),
                      const Divider(height: 1, color: AppTheme.borderLight),
                      const SizedBox(height: 20),

                      // Location & Neighborhood
                      const Text(
                        'Location & Neighborhood',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildLocationMapPreview(),

                      // Reviews & Ratings
                      if (widget.property.reviews.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        const Divider(height: 1, color: AppTheme.borderLight),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Client Reviews',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, color: AppTheme.accentColor, size: 18),
                                const SizedBox(width: 2),
                                Text(
                                  '${widget.property.rating}',
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        ...widget.property.reviews.map((r) => _buildReviewItem(r)),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Custom Top Header Buttons (Back & Favorite)
          _buildTopFloatingHeader(isFav, appState),

          // Bottom Action Bar
          _buildBottomFloatingBar(),
        ],
      ),
    );
  }

  Widget _buildImageCarousel() {
    return Stack(
      children: [
        SizedBox(
          height: 330,
          width: double.infinity,
          child: PageView.builder(
            itemCount: widget.property.images.length,
            onPageChanged: (idx) => setState(() => _currentImageIndex = idx),
            itemBuilder: (context, idx) {
              final imgPath = widget.property.images[idx];
              return imgPath.startsWith('assets/')
                  ? Image.asset(imgPath, fit: BoxFit.cover)
                  : Image.network(
                      imgPath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.image_not_supported, size: 40),
                      ),
                    );
            },
          ),
        ),
        // Image Indicator Dots
        Positioned(
          bottom: 16,
          right: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '${_currentImageIndex + 1}/${widget.property.images.length}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopFloatingHeader(bool isFav, AppState appState) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.92),
            radius: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppTheme.textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.92),
            radius: 20,
            child: IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border_rounded,
                color: isFav ? AppTheme.error : AppTheme.textPrimary,
                size: 22,
              ),
              onPressed: () {
                appState.toggleFavorite(widget.property.id);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSpecChip(Icons.bed_outlined, '${widget.property.bedrooms} Beds'),
        _buildSpecChip(Icons.bathtub_outlined, '${widget.property.bathrooms} Baths'),
        _buildSpecChip(Icons.square_foot_outlined, '${widget.property.areaSqft.toInt()} sqft'),
        _buildSpecChip(Icons.garage_outlined, '${widget.property.parkingSpaces} Park'),
      ],
    );
  }

  Widget _buildSpecChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.scaffoldBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppTheme.primaryColor),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgentCard(AppState appState) {
    final agent = widget.property.agent;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.scaffoldBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundImage: NetworkImage(agent.avatarUrl),
                backgroundColor: Colors.grey.shade300,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 10, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  agent.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  agent.agency,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: AppTheme.accentColor, size: 16),
                    const SizedBox(width: 2),
                    Text(
                      '${agent.rating}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ' (${agent.reviewsCount} reviews)',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Chat Button
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: AppTheme.primaryLight,
              padding: const EdgeInsets.all(10),
            ),
            icon: const Icon(Icons.chat_bubble_outline_rounded, color: AppTheme.primaryColor, size: 20),
            onPressed: () {
              final conv = appState.getOrCreateConversationForProperty(widget.property);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => ChatDetailScreen(conversation: conv),
                ),
              );
            },
          ),
          const SizedBox(width: 6),
          // Call Button
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: AppTheme.primaryLight,
              padding: const EdgeInsets.all(10),
            ),
            icon: const Icon(Icons.phone_outlined, color: AppTheme.primaryColor, size: 20),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Calling ${agent.name} (${agent.phone})...')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAmenitiesGrid() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: widget.property.amenities.map((amenity) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.scaffoldBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.borderLight),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getAmenityIcon(amenity),
                size: 16,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 6),
              Text(
                amenity,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLocationMapPreview() {
    final spots = widget.property.neighborhood.isNotEmpty
        ? widget.property.neighborhood
        : [
            const NeighborhoodSpot(title: 'Metro Transit', distance: '0.4 mi', category: 'Metro'),
            const NeighborhoodSpot(title: 'Academy School', distance: '0.8 mi', category: 'School'),
            const NeighborhoodSpot(title: 'General Hospital', distance: '1.2 mi', category: 'Hospital'),
            const NeighborhoodSpot(title: 'Shopping Mall', distance: '0.5 mi', category: 'Mall'),
          ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.scaffoldBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.map_rounded, color: AppTheme.primaryColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${widget.property.address}, ${widget.property.city}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Proximity points
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: spots.map((spot) {
              return Column(
                children: [
                  Icon(_getNeighborhoodIcon(spot.category), size: 18, color: AppTheme.textSecondary),
                  const SizedBox(height: 4),
                  Text(
                    spot.distance,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    spot.category,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(dynamic review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.scaffoldBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(review.userAvatar),
                backgroundColor: Colors.grey.shade300,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    Text(
                      review.date,
                      style: const TextStyle(color: AppTheme.textLight, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: AppTheme.accentColor, size: 16),
                  const SizedBox(width: 2),
                  Text(
                    '${review.rating}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review.comment,
            style: const TextStyle(fontSize: 12.5, color: AppTheme.textSecondary, height: 1.35),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomFloatingBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 14,
          bottom: MediaQuery.of(context).padding.bottom + 14,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Total Price',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      widget.property.formattedPrice,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    if (widget.property.priceSuffix.isNotEmpty)
                      Text(
                        widget.property.priceSuffix,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScheduleTourBottomSheet.show(context, widget.property);
                  },
                  icon: const Icon(Icons.calendar_month_rounded, size: 18),
                  label: const Text('Schedule Tour'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
