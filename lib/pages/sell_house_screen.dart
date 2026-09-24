import 'package:flutter/material.dart';
import '../models/property_model.dart';
import '../models/agent_model.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'property_detail_screen.dart';

class SellHouseScreen extends StatefulWidget {
  final Function(Property)? onPublished;

  const SellHouseScreen({super.key, this.onPublished});

  @override
  State<SellHouseScreen> createState() => _SellHouseScreenState();
}

class _SellHouseScreenState extends State<SellHouseScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _titleController = TextEditingController(text: 'Modern Panoramic Hillside Villa');
  final _priceController = TextEditingController(text: '1850000');
  final _addressController = TextEditingController(text: '9420 Wilshire Blvd');
  final _areaController = TextEditingController(text: '4200');
  final _yearBuiltController = TextEditingController(text: '2024');
  final _descriptionController = TextEditingController(
    text: 'A masterfully designed luxury residence featuring floor-to-ceiling glass windows, breathtaking panoramic views, custom Italian finishes, an infinity pool, and seamless indoor-outdoor entertaining spaces.',
  );
  final _customImageController = TextEditingController();

  // Selections
  PropertyType _selectedType = PropertyType.house;
  String _selectedCity = 'Los Angeles, CA';
  int _bedrooms = 4;
  int _bathrooms = 4;
  int _parkingSpaces = 3;
  bool _isPublishing = false;

  // Curated Luxury House Photos for selection
  final List<String> _availablePhotos = [
    'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=800&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1600566753376-12c8ab7fb75b?w=800&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800&auto=format&fit=crop&q=80',
  ];

  late Set<String> _selectedPhotos;

  // Available Luxury Amenities
  final List<String> _allAmenities = [
    'Swimming Pool',
    'Private Garden',
    'Smart Home Automation',
    '24/7 Security System',
    'Private Elevator',
    'Ocean / Skyline View',
    'Covered Garage',
    'Home Theater',
    'Wine Cellar',
    'Fitness Gym',
    'Spa & Sauna',
    'Balcony Terrace',
  ];

  late Set<String> _selectedAmenities;

  @override
  void initState() {
    super.initState();
    // Default selected photos & amenities
    _selectedPhotos = {
      _availablePhotos[0],
      _availablePhotos[1],
      _availablePhotos[2],
    };
    _selectedAmenities = {
      'Swimming Pool',
      'Smart Home Automation',
      'Private Garden',
      'Covered Garage',
      '24/7 Security System',
    };
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _addressController.dispose();
    _areaController.dispose();
    _yearBuiltController.dispose();
    _descriptionController.dispose();
    _customImageController.dispose();
    super.dispose();
  }

  void _addCustomPhoto() {
    final url = _customImageController.text.trim();
    if (url.isNotEmpty && (url.startsWith('http://') || url.startsWith('https://'))) {
      setState(() {
        _selectedPhotos.add(url);
        _customImageController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Photo added to gallery!'), backgroundColor: AppTheme.success),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid image URL'), backgroundColor: AppTheme.error),
      );
    }
  }

  Future<void> _handlePublish() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields correctly'), backgroundColor: AppTheme.error),
      );
      return;
    }

    if (_selectedPhotos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least 1 photo for your listing'), backgroundColor: AppTheme.error),
      );
      return;
    }

    setState(() => _isPublishing = true);

    final appState = AppStateScope.of(context);
    final price = double.tryParse(_priceController.text.trim().replaceAll(',', '')) ?? 1000000;
    final area = double.tryParse(_areaController.text.trim()) ?? 3000;
    final year = int.tryParse(_yearBuiltController.text.trim()) ?? DateTime.now().year;

    // Create seller agent representation
    final sellerAgent = Agent(
      id: 'seller_${appState.currentUser?.id ?? 'user'}',
      name: appState.userName,
      agency: 'Luxeylin Verified Private Seller',
      avatarUrl: appState.userAvatarUrl ??
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
      phone: appState.userPhone,
      email: appState.userEmail,
      rating: 5.0,
      reviewsCount: 1,
      about: 'Verified owner of luxury residential real estate on Luxeylin.',
      listingsCount: 1,
      isVerified: true,
    );

    final newProperty = Property(
      id: 'house_sale_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      price: price,
      priceSuffix: '', // Empty suffix for Sale!
      type: _selectedType,
      address: _addressController.text.trim(),
      city: _selectedCity,
      bedrooms: _bedrooms,
      bathrooms: _bathrooms,
      areaSqft: area,
      parkingSpaces: _parkingSpaces,
      yearBuilt: year,
      rating: 5.0,
      reviewsCount: 0,
      images: _selectedPhotos.toList(),
      amenities: _selectedAmenities.toList(),
      neighborhood: const [
        NeighborhoodSpot(title: 'Beverly Hills City Center', distance: '1.2 km', category: 'Mall'),
        NeighborhoodSpot(title: 'Metro Center', distance: '0.8 km', category: 'Metro'),
        NeighborhoodSpot(title: 'Premier International Academy', distance: '1.5 km', category: 'School'),
      ],
      reviews: const [],
      isFeatured: true,
      isForRent: false, // House for Sale
      agent: sellerAgent,
    );

    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;
    appState.addProperty(newProperty);
    setState(() => _isPublishing = false);

    if (widget.onPublished != null) {
      widget.onPublished!(newProperty);
    }

    _showSuccessDialog(newProperty);
  }

  void _showSuccessDialog(Property property) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: AppTheme.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_outline_rounded, color: AppTheme.primaryColor, size: 42),
            ),
            const SizedBox(height: 20),
            const Text(
              'House Listed for Sale! 🏡',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Your property "${property.title}" is now published and visible to buyers worldwide.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13.5, color: AppTheme.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) => PropertyDetailScreen(property: property),
                    ),
                  );
                },
                child: const Text('View Published Property'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Continue Browsing'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'List House for Sale',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.sell_rounded, size: 14, color: AppTheme.primaryColor),
                    SizedBox(width: 4),
                    Text(
                      'For Sale',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tips Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.borderLight),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.lightbulb_outline_rounded, color: AppTheme.accentColor, size: 24),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sell with Luxeylin Concierge',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Provide accurate details and luxury photos to attract verified high-net-worth buyers.',
                            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.3),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ===================================
              // SECTION 1: BASIC INFORMATION
              // ===================================
              _buildSectionTitle('1. Basic Information', 'Choose property type, title and asking price'),
              const SizedBox(height: 12),

              _buildCard([
                // Property Type Selector
                const Text('Property Type', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: PropertyType.values.map((type) {
                    final isSelected = _selectedType == type;
                    return ChoiceChip(
                      label: Text(type.displayName),
                      selected: isSelected,
                      selectedColor: AppTheme.primaryColor,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppTheme.textPrimary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12.5,
                      ),
                      onSelected: (val) {
                        if (val) setState(() => _selectedType = type);
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 18),

                // Title
                const Text('Listing Title', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Modern Sunset Villa with Ocean View',
                    prefixIcon: Icon(Icons.home_outlined, color: AppTheme.textLight),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Please enter a listing title';
                    if (val.trim().length < 5) return 'Title must be at least 5 characters';
                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // Sale Price
                const Text('Asking Price (\$ USD)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'e.g. 1850000',
                    prefixIcon: Icon(Icons.attach_money_rounded, color: AppTheme.textLight),
                    helperText: 'One-time sale purchase price',
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Please enter asking price';
                    final num = double.tryParse(val.replaceAll(',', ''));
                    if (num == null || num <= 0) return 'Please enter a valid price';
                    return null;
                  },
                ),
              ]),

              const SizedBox(height: 24),

              // ===================================
              // SECTION 2: SPECIFICATIONS
              // ===================================
              _buildSectionTitle('2. Property Specifications', 'Bedrooms, bathrooms, square footage and parking'),
              const SizedBox(height: 12),

              _buildCard([
                Row(
                  children: [
                    Expanded(
                      child: _buildCounterField(
                        label: 'Bedrooms',
                        value: _bedrooms,
                        onDecrement: () {
                          if (_bedrooms > 1) setState(() => _bedrooms--);
                        },
                        onIncrement: () => setState(() => _bedrooms++),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildCounterField(
                        label: 'Bathrooms',
                        value: _bathrooms,
                        onDecrement: () {
                          if (_bathrooms > 1) setState(() => _bathrooms--);
                        },
                        onIncrement: () => setState(() => _bathrooms++),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Living Area (Sq Ft)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _areaController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'e.g. 4200',
                              prefixIcon: Icon(Icons.square_foot_rounded, color: AppTheme.textLight),
                            ),
                            validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildCounterField(
                        label: 'Garage Parking',
                        value: _parkingSpaces,
                        onDecrement: () {
                          if (_parkingSpaces > 0) setState(() => _parkingSpaces--);
                        },
                        onIncrement: () => setState(() => _parkingSpaces++),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                const Text('Year Built', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _yearBuiltController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'e.g. 2024',
                    prefixIcon: Icon(Icons.calendar_today_outlined, color: AppTheme.textLight),
                  ),
                ),
              ]),

              const SizedBox(height: 24),

              // ===================================
              // SECTION 3: LOCATION & CITY
              // ===================================
              _buildSectionTitle('3. Location & Address', 'Where is this property located?'),
              const SizedBox(height: 12),

              _buildCard([
                const Text('Street Address', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. 9420 Wilshire Blvd, Beverly Hills',
                    prefixIcon: Icon(Icons.location_on_outlined, color: AppTheme.textLight),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter property address' : null,
                ),

                const SizedBox(height: 16),

                const Text('City & Region', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedCity,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.apartment_rounded, color: AppTheme.textLight),
                  ),
                  items: AppState.availableLocations.map((loc) {
                    return DropdownMenuItem(value: loc, child: Text(loc));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedCity = val);
                  },
                ),
              ]),

              const SizedBox(height: 24),

              // ===================================
              // SECTION 4: GALLERY & PHOTOS
              // ===================================
              _buildSectionTitle('4. Property Photos (${_selectedPhotos.length} selected)', 'Choose luxury photos for the listing showcase'),
              const SizedBox(height: 12),

              _buildCard([
                const Text('Select from Curated Luxury Photos:', style: TextStyle(fontSize: 12.5, color: AppTheme.textSecondary)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 120,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _availablePhotos.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, idx) {
                      final photoUrl = _availablePhotos[idx];
                      final isPicked = _selectedPhotos.contains(photoUrl);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isPicked) {
                              if (_selectedPhotos.length > 1) {
                                _selectedPhotos.remove(photoUrl);
                              }
                            } else {
                              _selectedPhotos.add(photoUrl);
                            }
                          });
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isPicked ? AppTheme.primaryColor : AppTheme.borderLight,
                                  width: isPicked ? 2.5 : 1,
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(photoUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            if (isPicked)
                              Positioned(
                                right: 6,
                                top: 6,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                    color: AppTheme.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.check, color: Colors.white, size: 14),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Add custom image URL
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _customImageController,
                        decoration: const InputDecoration(
                          hintText: 'Paste custom image URL (optional)',
                          prefixIcon: Icon(Icons.add_photo_alternate_outlined, color: AppTheme.textLight),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _addCustomPhoto,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ]),

              const SizedBox(height: 24),

              // ===================================
              // SECTION 5: LUXURY AMENITIES
              // ===================================
              _buildSectionTitle('5. Luxury Amenities', 'Highlight key architectural & lifestyle features'),
              const SizedBox(height: 12),

              _buildCard([
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _allAmenities.map((amenity) {
                    final isSelected = _selectedAmenities.contains(amenity);
                    return FilterChip(
                      label: Text(amenity),
                      selected: isSelected,
                      selectedColor: AppTheme.primaryLight,
                      checkmarkColor: AppTheme.primaryColor,
                      labelStyle: TextStyle(
                        color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        fontSize: 12.5,
                      ),
                      onSelected: (val) {
                        setState(() {
                          if (val) {
                            _selectedAmenities.add(amenity);
                          } else {
                            _selectedAmenities.remove(amenity);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ]),

              const SizedBox(height: 24),

              // ===================================
              // SECTION 6: DESCRIPTION
              // ===================================
              _buildSectionTitle('6. Property Story & Description', 'Tell buyers what makes this house unique'),
              const SizedBox(height: 12),

              _buildCard([
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Describe views, architecture, interior design, security, and surroundings...',
                  ),
                  validator: (v) => (v == null || v.trim().length < 20)
                      ? 'Please provide a detailed description (at least 20 characters)'
                      : null,
                ),
              ]),

              const SizedBox(height: 24),

              // ===================================
              // SECTION 7: SELLER PROFILE
              // ===================================
              _buildSectionTitle('7. Seller Profile', 'Buyers will contact you through this profile'),
              const SizedBox(height: 12),

              _buildCard([
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: appState.userAvatarUrl != null
                          ? NetworkImage(appState.userAvatarUrl!)
                          : null,
                      child: appState.userAvatarUrl == null ? const Icon(Icons.person) : null,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appState.userName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Text(
                            '${appState.userEmail} • ${appState.userPhone}',
                            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Verified',
                        style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ]),

              const SizedBox(height: 32),

              // ===================================
              // PUBLISH BUTTON
              // ===================================
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _isPublishing ? null : _handlePublish,
                  icon: _isPublishing
                      ? const SizedBox.shrink()
                      : const Icon(Icons.publish_rounded, color: Colors.white),
                  label: _isPublishing
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        )
                      : const Text(
                          'Publish House for Sale',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildCounterField({
    required String label,
    required int value,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: AppTheme.scaffoldBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.borderLight),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.remove, size: 18),
                onPressed: onDecrement,
                color: AppTheme.textPrimary,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Text(
                '$value',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              ),
              IconButton(
                icon: const Icon(Icons.add, size: 18),
                onPressed: onIncrement,
                color: AppTheme.primaryColor,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
