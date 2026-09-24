import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/property_model.dart';
import '../models/user_model.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static const String _keyFavorites = 'luxeylin_favorite_ids';
  static const String _keyCustomProperties = 'luxeylin_custom_properties';
  static const String _keyScheduledTours = 'luxeylin_scheduled_tours';
  static const String _keyUserProfile = 'luxeylin_user_profile';
  static const String _keyDarkMode = 'luxeylin_dark_mode';
  static const String _keyCompareList = 'luxeylin_compare_ids';

  SharedPreferences? _prefs;

  Future<void> init() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
    } catch (_) {
      // Fallback if platform fails or in headless tests
    }
  }

  // -------------------------------------------------------------
  // FAVORITES
  // -------------------------------------------------------------
  Set<String> getFavoriteIds() {
    final list = _prefs?.getStringList(_keyFavorites);
    if (list != null) {
      return list.toSet();
    }
    return {'prop_1', 'prop_3'};
  }

  Future<void> saveFavoriteIds(Set<String> ids) async {
    await _prefs?.setStringList(_keyFavorites, ids.toList());
  }

  // -------------------------------------------------------------
  // CUSTOM PROPERTIES (User Listed Properties)
  // -------------------------------------------------------------
  List<Property> getCustomProperties() {
    final raw = _prefs?.getString(_keyCustomProperties);
    if (raw == null || raw.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      return list.map((item) => Property.fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveCustomProperties(List<Property> properties) async {
    try {
      final data = properties.map((p) => p.toJson()).toList();
      await _prefs?.setString(_keyCustomProperties, jsonEncode(data));
    } catch (_) {}
  }

  // -------------------------------------------------------------
  // USER PROFILE
  // -------------------------------------------------------------
  UserModel? getUserProfile() {
    final raw = _prefs?.getString(_keyUserProfile);
    if (raw == null || raw.isEmpty) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return UserModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveUserProfile(UserModel user) async {
    try {
      await _prefs?.setString(_keyUserProfile, jsonEncode(user.toJson()));
    } catch (_) {}
  }

  // -------------------------------------------------------------
  // THEME PREFERENCE
  // -------------------------------------------------------------
  bool? getDarkMode() {
    return _prefs?.getBool(_keyDarkMode);
  }

  Future<void> saveDarkMode(bool isDark) async {
    await _prefs?.setBool(_keyDarkMode, isDark);
  }

  // -------------------------------------------------------------
  // SCHEDULED TOURS DATA
  // -------------------------------------------------------------
  List<Map<String, dynamic>> getScheduledTours() {
    final raw = _prefs?.getString(_keyScheduledTours);
    if (raw == null || raw.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      return list.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveScheduledTours(List<Map<String, dynamic>> tours) async {
    try {
      await _prefs?.setString(_keyScheduledTours, jsonEncode(tours));
    } catch (_) {}
  }

  // -------------------------------------------------------------
  // COMPARE IDS
  // -------------------------------------------------------------
  List<String> getCompareIds() {
    return _prefs?.getStringList(_keyCompareList) ?? [];
  }

  Future<void> saveCompareIds(List<String> ids) async {
    await _prefs?.setStringList(_keyCompareList, ids);
  }
}
