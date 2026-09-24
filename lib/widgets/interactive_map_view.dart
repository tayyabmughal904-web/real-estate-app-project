import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/property_model.dart';
import '../theme/app_theme.dart';
import '../pages/property_detail_screen.dart';

class InteractiveMapView extends StatefulWidget {
  final List<Property> properties;
  final Function(Property)? onPropertyTap;

  const InteractiveMapView({
    super.key,
    required this.properties,
    this.onPropertyTap,
  });

  @override
  State<InteractiveMapView> createState() => _InteractiveMapViewState();
}

class _InteractiveMapViewState extends State<InteractiveMapView> {
  final TransformationController _transformationController = TransformationController();
  Property? _selectedProperty;

  @override
  void initState() {
    super.initState();
    if (widget.properties.isNotEmpty) {
      _selectedProperty = widget.properties.first;
    }
  }

  void _zoomIn() {
    final matrix = _transformationController.value.clone();
    matrix.scale(1.25);
    _transformationController.value = matrix;
  }

  void _zoomOut() {
    final matrix = _transformationController.value.clone();
    matrix.scale(0.8);
    _transformationController.value = matrix;
  }

  void _resetMap() {
    _transformationController.value = Matrix4.identity();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mapBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0);
    final roadColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final parkColor = isDark ? const Color(0xFF064E3B).withValues(alpha: 0.35) : const Color(0xFFDCFCE7);
    final waterColor = isDark ? const Color(0xFF0C4A6E).withValues(alpha: 0.35) : const Color(0xFFBAE6FD);

    return Stack(
      children: [
        // Interactive Canvas
        ClipRect(
          child: InteractiveViewer(
            transformationController: _transformationController,
            minScale: 0.7,
            maxScale: 3.5,
            boundaryMargin: const EdgeInsets.all(300),
            child: SizedBox(
              width: 1200,
              height: 1200,
              child: Stack(
                children: [
                  // Vector Map Base Layer
                  CustomPaint(
                    size: const Size(1200, 1200),
                    painter: _LuxuryMapPainter(
                      mapBg: mapBg,
                      roadColor: roadColor,
                      parkColor: parkColor,
                      waterColor: waterColor,
                      isDark: isDark,
                    ),
                  ),

                  // Property Pins
                  ...widget.properties.asMap().entries.map((entry) {
                    final index = entry.key;
                    final property = entry.value;
                    final isSelected = _selectedProperty?.id == property.id;

                    // Compute pseudo-geographic positions for realistic distributed layout
                    final pinPositions = [
                      const Offset(450, 480),
                      const Offset(680, 390),
                      const Offset(350, 720),
                      const Offset(820, 680),
                      const Offset(520, 790),
                      const Offset(760, 510),
                    ];
                    final pos = index < pinPositions.length
                        ? pinPositions[index]
                        : Offset(
                            300 + (index * 110.0) % 600,
                            350 + (index * 130.0) % 550,
                          );

                    return Positioned(
                      left: pos.dx - (isSelected ? 55 : 45),
                      top: pos.dy - 35,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedProperty = property;
                          });
                          if (widget.onPropertyTap != null) {
                            widget.onPropertyTap!(property);
                          }
                        },
                        child: AnimatedScale(
                          scale: isSelected ? 1.15 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          child: _buildPricePin(property, isSelected, isDark),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),

        // Floating Top Toolbar (Property Count Badge)
        Positioned(
          top: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkCardBg : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isDark ? AppTheme.darkBorder : AppTheme.borderLight),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${widget.properties.length} Homes on Map',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Floating Map Controls (+, -, Center)
        Positioned(
          top: 16,
          right: 16,
          child: Column(
            children: [
              _buildControlButton(
                icon: Icons.add,
                onPressed: _zoomIn,
                tooltip: 'Zoom In',
                isDark: isDark,
              ),
              const SizedBox(height: 8),
              _buildControlButton(
                icon: Icons.remove,
                onPressed: _zoomOut,
                tooltip: 'Zoom Out',
                isDark: isDark,
              ),
              const SizedBox(height: 8),
              _buildControlButton(
                icon: Icons.my_location_rounded,
                onPressed: _resetMap,
                tooltip: 'Reset View',
                isDark: isDark,
              ),
            ],
          ),
        ),

        // Bottom Selected Property Card
        if (_selectedProperty != null)
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: _buildBottomPreviewCard(_selectedProperty!, isDark),
          ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCardBg : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: isDark ? AppTheme.darkBorder : AppTheme.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 20),
        color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
        tooltip: tooltip,
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildPricePin(Property property, bool isSelected, bool isDark) {
    final bgColor = isSelected
        ? AppTheme.primaryColor
        : (isDark ? const Color(0xFF1E293B) : Colors.white);
    final textColor = isSelected
        ? Colors.white
        : (isDark ? Colors.white : AppTheme.textPrimary);
    final borderColor = isSelected
        ? Colors.white
        : (isDark ? AppTheme.darkBorder : AppTheme.borderLight);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? AppTheme.primaryColor.withValues(alpha: 0.4)
                    : Colors.black.withValues(alpha: 0.15),
                blurRadius: isSelected ? 12 : 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                property.isForRent ? Icons.key_rounded : Icons.home_rounded,
                size: 13,
                color: isSelected ? Colors.white : AppTheme.primaryColor,
              ),
              const SizedBox(width: 4),
              Text(
                property.formattedPrice,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        // Pin Pointer Triangle
        CustomPaint(
          size: const Size(10, 6),
          painter: _TrianglePainter(color: bgColor),
        ),
      ],
    );
  }

  Widget _buildBottomPreviewCard(Property property, bool isDark) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => PropertyDetailScreen(property: property),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkCardBg : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: isDark ? AppTheme.darkBorder : AppTheme.borderLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 90,
                height: 90,
                child: property.images.isNotEmpty
                    ? (property.images.first.startsWith('assets/')
                        ? Image.asset(property.images.first, fit: BoxFit.cover)
                        : Image.network(
                            property.images.first,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                              child: const Icon(Icons.image, color: Colors.grey),
                            ),
                          ))
                    : Container(color: Colors.grey.shade200),
              ),
            ),
            const SizedBox(width: 14),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        property.formattedPrice + property.priceSuffix,
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
                            '${property.rating}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    property.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    property.address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _buildMiniBadge('${property.bedrooms} Beds', isDark),
                      const SizedBox(width: 6),
                      _buildMiniBadge('${property.bathrooms} Baths', isDark),
                      const SizedBox(width: 6),
                      _buildMiniBadge('${property.areaSqft.toInt()} sqft', isDark),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniBadge(String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w500,
          color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
        ),
      ),
    );
  }
}

class _LuxuryMapPainter extends CustomPainter {
  final Color mapBg;
  final Color roadColor;
  final Color parkColor;
  final Color waterColor;
  final bool isDark;

  _LuxuryMapPainter({
    required this.mapBg,
    required this.roadColor,
    required this.parkColor,
    required this.waterColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = mapBg;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Water Body (Coastline / Bay)
    final waterPaint = Paint()..color = waterColor;
    final waterPath = Path()
      ..moveTo(size.width * 0.7, 0)
      ..cubicTo(
        size.width * 0.75,
        size.height * 0.3,
        size.width * 0.85,
        size.height * 0.6,
        size.width,
        size.height * 0.7,
      )
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(waterPath, waterPaint);

    // Parks / Green Zones
    final parkPaint = Paint()..color = parkColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(200, 250, 220, 180),
        const Radius.circular(30),
      ),
      parkPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(650, 750, 280, 220),
        const Radius.circular(40),
      ),
      parkPaint,
    );

    // Street Network (Main Boulevards & Avenues)
    final arterialPaint = Paint()
      ..color = roadColor
      ..strokeWidth = 22
      ..style = PaintingStyle.stroke;

    final secondaryPaint = Paint()
      ..color = roadColor
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke;

    // Arterials
    canvas.drawLine(const Offset(0, 350), Offset(size.width, 420), arterialPaint);
    canvas.drawLine(const Offset(0, 750), Offset(size.width, 700), arterialPaint);
    canvas.drawLine(const Offset(480, 0), const Offset(520, 1200), arterialPaint);
    canvas.drawLine(const Offset(820, 0), const Offset(780, 1200), arterialPaint);

    // Secondaries
    for (int y = 150; y < 1200; y += 150) {
      canvas.drawLine(Offset(0, y.toDouble()), Offset(size.width, y.toDouble()), secondaryPaint);
    }
    for (int x = 180; x < 1200; x += 160) {
      canvas.drawLine(Offset(x.toDouble(), 0), Offset(x.toDouble(), size.height), secondaryPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _LuxuryMapPainter oldDelegate) {
    return oldDelegate.mapBg != mapBg ||
        oldDelegate.roadColor != roadColor ||
        oldDelegate.isDark != isDark;
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TrianglePainter oldDelegate) => oldDelegate.color != color;
}
