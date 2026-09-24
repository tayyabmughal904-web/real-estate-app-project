import 'package:flutter/material.dart';
import '../models/property_model.dart';
import '../theme/app_theme.dart';

class VirtualTourSheet extends StatefulWidget {
  final Property property;

  const VirtualTourSheet({super.key, required this.property});

  static void show(BuildContext context, Property property) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => VirtualTourSheet(property: property),
    );
  }

  @override
  State<VirtualTourSheet> createState() => _VirtualTourSheetState();
}

class _VirtualTourSheetState extends State<VirtualTourSheet> {
  int _selectedRoomIndex = 0;
  double _panOffset = 0.0;
  double _compassAngle = 0.0;

  final List<Map<String, dynamic>> _rooms = [
    {
      'name': 'Living Room',
      'image': 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=1600&auto=format&fit=crop&q=80',
      'hotspots': [
        {'title': 'Floor-to-Ceiling Glass', 'desc': 'Automated thermal smart glass with UV filter', 'x': 0.35, 'y': 0.45},
        {'title': 'Italian Terrazzo Flooring', 'desc': 'Heated radiant stone slabs with integrated floor lighting', 'x': 0.65, 'y': 0.75},
      ],
    },
    {
      'name': 'Master Suite',
      'image': 'https://images.unsplash.com/photo-1600566753376-12c8ab7fb75b?w=1600&auto=format&fit=crop&q=80',
      'hotspots': [
        {'title': 'Walk-In Dressing Room', 'desc': 'Custom walnut cabinetry with biometric jewelry safe', 'x': 0.25, 'y': 0.5},
        {'title': 'Private Sunset Balcony', 'desc': 'Direct private access to west-facing skyline terrace', 'x': 0.75, 'y': 0.4},
      ],
    },
    {
      'name': 'Chef Kitchen',
      'image': 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=1600&auto=format&fit=crop&q=80',
      'hotspots': [
        {'title': 'Sub-Zero & Wolf Appliances', 'desc': 'Professional commercial grade refrigeration & gas range', 'x': 0.4, 'y': 0.55},
        {'title': 'Waterfall Calacatta Marble', 'desc': 'Single slab 14ft island with breakfast bar seating', 'x': 0.6, 'y': 0.65},
      ],
    },
    {
      'name': 'Pool Terrace',
      'image': 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=1600&auto=format&fit=crop&q=80',
      'hotspots': [
        {'title': 'Zero-Edge Infinity Pool', 'desc': 'Saltwater heated pool with integrated underwater sound system', 'x': 0.5, 'y': 0.7},
        {'title': 'Outdoor Kitchen & BBQ', 'desc': 'Teppanyaki grill, pizza oven, and outdoor refrigeration', 'x': 0.8, 'y': 0.5},
      ],
    },
  ];

  void _showHotspotDetails(Map<String, dynamic> hotspot) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.info_outline_rounded, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                hotspot['title'] as String,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
        content: Text(
          hotspot['desc'] as String,
          style: const TextStyle(color: Colors.white70, fontSize: 13.5),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentRoom = _rooms[_selectedRoomIndex];
    final hotspots = currentRoom['hotspots'] as List<Map<String, dynamic>>;

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Stack(
          children: [
            // 360 Panoramic Drag Area
            GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  _panOffset += details.primaryDelta! * 1.5;
                  _compassAngle += details.primaryDelta! * 0.005;
                });
              },
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      // Panning Panoramic Image Background
                      Positioned.fill(
                        child: Transform.translate(
                          offset: Offset(_panOffset % constraints.maxWidth - constraints.maxWidth, 0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: constraints.maxWidth,
                                height: constraints.maxHeight,
                                child: Image.network(
                                  currentRoom['image'] as String,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                width: constraints.maxWidth,
                                height: constraints.maxHeight,
                                child: Image.network(
                                  currentRoom['image'] as String,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Interactive Hotspots
                      ...hotspots.map((spot) {
                        final posX = (spot['x'] as double) * constraints.maxWidth;
                        final posY = (spot['y'] as double) * constraints.maxHeight;

                        return Positioned(
                          left: posX - 20,
                          top: posY - 20,
                          child: GestureDetector(
                            onTap: () => _showHotspotDetails(spot),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.6),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryColor.withValues(alpha: 0.6),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.touch_app_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
            ),

            // Top Header: Title & Compass & Close
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.threed_rotation_rounded, color: AppTheme.primaryColor, size: 18),
                        const SizedBox(width: 6),
                        const Text(
                          '360° Virtual Tour',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      // Simulated Compass
                      Transform.rotate(
                        angle: _compassAngle,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.explore_rounded, color: Colors.white, size: 20),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: Colors.black.withValues(alpha: 0.6),
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Hint Drag Overlay
            Positioned(
              bottom: 85,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.swipe_rounded, color: Colors.white70, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Drag horizontally to explore 360° • Tap glowing dots for specs',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Room Switcher Bar
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  itemCount: _rooms.length,
                  itemBuilder: (context, idx) {
                    final isSelected = _selectedRoomIndex == idx;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedRoomIndex = idx),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.primaryColor : Colors.white10,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            _rooms[idx]['name'] as String,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.5,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
