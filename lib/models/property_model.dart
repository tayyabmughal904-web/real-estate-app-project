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

  factory NeighborhoodSpot.fromJson(Map<String, dynamic> json) {
    return NeighborhoodSpot(
      title: json['title'] as String? ?? '',
      distance: json['distance'] as String? ?? '',
      category: json['category'] as String? ?? 'Place',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'distance': distance,
      'category': category,
    };
  }
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
  final double latitude;
  final double longitude;
  final String status; // 'Active', 'Pending', 'Sold'

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
    this.latitude = 34.0522,
    this.longitude = -118.2437,
    this.status = 'Active',
  });

  double get pricePerSqft => areaSqft > 0 ? price / areaSqft : 0;

  String get formattedPrice {
    if (price >= 1000000) {
      return '\$${(price / 1000000).toStringAsFixed(1)}M';
    } else if (price >= 1000) {
      return '\$${price.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      )}';
    }
    return '\$${price.toStringAsFixed(0)}';
  }

  Property copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? priceSuffix,
    PropertyType? type,
    String? address,
    String? city,
    int? bedrooms,
    int? bathrooms,
    double? areaSqft,
    int? parkingSpaces,
    int? yearBuilt,
    double? rating,
    int? reviewsCount,
    List<String>? images,
    List<String>? amenities,
    List<NeighborhoodSpot>? neighborhood,
    List<PropertyReview>? reviews,
    bool? isFeatured,
    bool? isForRent,
    Agent? agent,
    double? latitude,
    double? longitude,
    String? status,
  }) {
    return Property(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      priceSuffix: priceSuffix ?? this.priceSuffix,
      type: type ?? this.type,
      address: address ?? this.address,
      city: city ?? this.city,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      areaSqft: areaSqft ?? this.areaSqft,
      parkingSpaces: parkingSpaces ?? this.parkingSpaces,
      yearBuilt: yearBuilt ?? this.yearBuilt,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      images: images ?? this.images,
      amenities: amenities ?? this.amenities,
      neighborhood: neighborhood ?? this.neighborhood,
      reviews: reviews ?? this.reviews,
      isFeatured: isFeatured ?? this.isFeatured,
      isForRent: isForRent ?? this.isForRent,
      agent: agent ?? this.agent,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
    );
  }

  factory Property.fromJson(Map<String, dynamic> json) {
    PropertyType parseType(String? val) {
      return PropertyType.values.firstWhere(
        (t) => t.name == val || t.displayName.toLowerCase() == val?.toLowerCase(),
        orElse: () => PropertyType.house,
      );
    }

    return Property(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      priceSuffix: json['priceSuffix'] as String? ?? '',
      type: parseType(json['type'] as String?),
      address: json['address'] as String? ?? '',
      city: json['city'] as String? ?? '',
      bedrooms: json['bedrooms'] as int? ?? 1,
      bathrooms: json['bathrooms'] as int? ?? 1,
      areaSqft: (json['areaSqft'] as num?)?.toDouble() ?? 1000,
      parkingSpaces: json['parkingSpaces'] as int? ?? 1,
      yearBuilt: json['yearBuilt'] as int? ?? 2023,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      reviewsCount: json['reviewsCount'] as int? ?? 0,
      images: (json['images'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      amenities: (json['amenities'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      neighborhood: (json['neighborhood'] as List<dynamic>?)
              ?.map((e) => NeighborhoodSpot.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      reviews: (json['reviews'] as List<dynamic>?)
              ?.map((e) => PropertyReview.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      isFeatured: json['isFeatured'] as bool? ?? false,
      isForRent: json['isForRent'] as bool? ?? false,
      agent: json['agent'] != null
          ? Agent.fromJson(json['agent'] as Map<String, dynamic>)
          : const Agent(
              id: 'agent_default',
              name: 'Sarah Jenkins',
              agency: 'Luxeylin Realty',
              avatarUrl: '',
              phone: '',
              email: '',
              rating: 4.9,
              reviewsCount: 100,
              about: '',
            ),
      latitude: (json['latitude'] as num?)?.toDouble() ?? 34.0522,
      longitude: (json['longitude'] as num?)?.toDouble() ?? -118.2437,
      status: json['status'] as String? ?? 'Active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'priceSuffix': priceSuffix,
      'type': type.name,
      'address': address,
      'city': city,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'areaSqft': areaSqft,
      'parkingSpaces': parkingSpaces,
      'yearBuilt': yearBuilt,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'images': images,
      'amenities': amenities,
      'neighborhood': neighborhood.map((n) => n.toJson()).toList(),
      'reviews': reviews.map((r) => r.toJson()).toList(),
      'isFeatured': isFeatured,
      'isForRent': isForRent,
      'agent': agent.toJson(),
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
    };
  }
}
