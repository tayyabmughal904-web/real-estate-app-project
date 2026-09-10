import 'agent_model.dart';
import 'review_model.dart';

enum PropertyType {
  house('House'),
  apartment('Apartment'),
  villa('Villa'),
  penthouse('Penthouse'),
  commercial('Commercial');

  final String displayName;
  const PropertyType(this.displayName);
}

class NeighborhoodSpot {
  final String title;
  final String distance;
  final String category; // 'Metro', 'School', 'Hospital', 'Mall', 'Airport', 'Beach'

  const NeighborhoodSpot({
    required this.title,
    required this.distance,
    required this.category,
  });
}

class Property {
  final String id;
  final String title;
  final String description;
  final double price;
  final String priceSuffix; // e.g. "/mo" or ""
  final PropertyType type;
  final String address;
  final String city;
  final int bedrooms;
  final int bathrooms;
  final double areaSqft;
  final int parkingSpaces;
  final int yearBuilt;
  final double rating;
  final int reviewsCount;
  final List<String> images;
  final List<String> amenities;
  final List<NeighborhoodSpot> neighborhood;
  final List<PropertyReview> reviews;
  final bool isFeatured;
  final bool isForRent;
  final Agent agent;

  const Property({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.priceSuffix = '/mo',
    required this.type,
    required this.address,
    required this.city,
    required this.bedrooms,
    required this.bathrooms,
    required this.areaSqft,
    required this.parkingSpaces,
    required this.yearBuilt,
    required this.rating,
    required this.reviewsCount,
    required this.images,
    required this.amenities,
    this.neighborhood = const [],
    this.reviews = const [],
    this.isFeatured = false,
    this.isForRent = true,
    required this.agent,
  });

  String get formattedPrice {
    if (price >= 1000000) {
      return '\$${(price / 1000000).toStringAsFixed(1)}M';
    } else if (price >= 1000) {
      // Formatted with commas
      return '\$${price.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      )}';
    }
    return '\$${price.toStringAsFixed(0)}';
  }
}
