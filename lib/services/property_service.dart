import 'dart:async';
import 'package:flutter/material.dart';
import '../models/property_model.dart';
import '../data/mock_data.dart';
import 'api_response.dart';

class PropertyService {
  static final PropertyService _instance = PropertyService._internal();
  factory PropertyService() => _instance;
  PropertyService._internal() {
    _properties = List<Property>.from(MockData.properties);
  }

  List<Property> _properties = [];
  final Set<String> _favoriteIds = {'prop_1', 'prop_3'};

  /// Get all properties with optional filtering
  Future<ApiResponse<List<Property>>> getProperties({
    String? query,
    PropertyType? type,
    bool? forRent,
    RangeValues? priceRange,
    int? minBeds,
    int? minBaths,
  }) async {
    await Future.delayed(const Duration(milliseconds: 350));

    var results = List<Property>.from(_properties);

    if (query != null && query.trim().isNotEmpty) {
      final q = query.toLowerCase();
      results = results.where((p) {
        return p.title.toLowerCase().contains(q) ||
            p.address.toLowerCase().contains(q) ||
            p.city.toLowerCase().contains(q) ||
            p.type.displayName.toLowerCase().contains(q);
      }).toList();
    }

    if (type != null) {
      results = results.where((p) => p.type == type).toList();
    }

    if (forRent != null) {
      results = results.where((p) => p.isForRent == forRent).toList();
    }

    if (priceRange != null) {
      results = results
          .where((p) => p.price >= priceRange.start && p.price <= priceRange.end)
          .toList();
    }

    if (minBeds != null && minBeds > 0) {
      results = results.where((p) => p.bedrooms >= minBeds).toList();
    }

    if (minBaths != null && minBaths > 0) {
      results = results.where((p) => p.bathrooms >= minBaths).toList();
    }

    return ApiResponse.success(results);
  }

  /// Get property by ID
  Future<ApiResponse<Property>> getPropertyById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _properties.indexWhere((p) => p.id == id);
    if (index != -1) {
      return ApiResponse.success(_properties[index]);
    }
    return ApiResponse.error('Property not found', statusCode: 404);
  }

  /// Toggle Favorite
  Future<ApiResponse<bool>> toggleFavorite(String propertyId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final isFav = _favoriteIds.contains(propertyId);
    if (isFav) {
      _favoriteIds.remove(propertyId);
    } else {
      _favoriteIds.add(propertyId);
    }
    return ApiResponse.success(!isFav);
  }

  /// Add a new property (e.g. house for sale)
  Future<ApiResponse<Property>> addProperty(Property property) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _properties.insert(0, property);
    return ApiResponse.success(property, message: 'Property listed successfully');
  }

  Set<String> get favoriteIds => Set.unmodifiable(_favoriteIds);
}
