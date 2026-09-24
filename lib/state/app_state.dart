import 'package:flutter/material.dart';
import '../models/property_model.dart';
import '../models/chat_model.dart';
import '../models/notification_model.dart';
import '../models/user_model.dart';
import '../models/agent_model.dart';
import '../data/mock_data.dart';
import '../services/api_response.dart';
import '../services/auth_service.dart';
import '../services/property_service.dart';
import '../services/chat_service.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';

enum PropertySortOption {
  recommended('Recommended'),
  priceLowToHigh('Price: Low to High'),
  priceHighToLow('Price: High to Low'),
  topRated('Highest Rated');

  final String displayName;
  const PropertySortOption(this.displayName);
}

class ScheduledTour {
  final String id;
  final Property property;
  final DateTime date;
  final String timeSlot;
  final String tourType; // 'In-Person Tour' or 'Video Call'

  const ScheduledTour({
    required this.id,
    required this.property,
    required this.date,
    required this.timeSlot,
    required this.tourType,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'property': property.toJson(),
      'date': date.toIso8601String(),
      'timeSlot': timeSlot,
      'tourType': tourType,
    };
  }

  factory ScheduledTour.fromJson(Map<String, dynamic> json) {
    return ScheduledTour(
      id: json['id'] as String,
      property: Property.fromJson(json['property'] as Map<String, dynamic>),
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      timeSlot: json['timeSlot'] as String? ?? '11:00 AM',
      tourType: json['tourType'] as String? ?? 'In-Person Tour',
    );
  }
}

class AppState extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final PropertyService _propertyService = PropertyService();
  final ChatService _chatService = ChatService();
  final NotificationService _notificationService = NotificationService();
  final StorageService _storageService = StorageService();

  // Authentication & Current User
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser ?? _authService.currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool _isAuthLoading = false;
  bool get isAuthLoading => _isAuthLoading;
  String? _authError;
  String? get authError => _authError;

  // Properties
  List<Property> _properties = [];
  List<Property> get properties => _properties.isNotEmpty ? _properties : MockData.properties;

  // Favorite Property IDs
  Set<String> _favoriteIds = {'prop_1', 'prop_3'};
  Set<String> get favoriteIds => _favoriteIds;

  List<Property> get favoriteProperties =>
      properties.where((p) => _favoriteIds.contains(p.id)).toList();

  bool isFavorite(String propertyId) => _favoriteIds.contains(propertyId);

  void toggleFavorite(String propertyId) {
    if (_favoriteIds.contains(propertyId)) {
      _favoriteIds.remove(propertyId);
    } else {
      _favoriteIds.add(propertyId);
    }
    _propertyService.toggleFavorite(propertyId);
    _storageService.saveFavoriteIds(_favoriteIds);
    notifyListeners();
  }

  void addProperty(Property property) {
    _properties.insert(0, property);
    _propertyService.addProperty(property);

    // Save custom properties to persistent storage
    final customList = _properties
        .where((p) => p.agent.id == 'user_agent' || p.id.startsWith('user_prop_') || p.id.startsWith('prop_custom_') || p.agent.name == userName)
        .toList();
    _storageService.saveCustomProperties(customList);

    // Add a notification for listing creation
    final notif = AppNotification(
      id: 'notif_listing_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Property Listed for Sale 🏡',
      message: 'Your listing "${property.title}" is now live on Luxeylin.',
      timestamp: DateTime.now(),
      type: NotificationType.system,
      propertyId: property.id,
    );
    _notifications.insert(0, notif);
    _notificationService.addNotification(notif);

    notifyListeners();
  }

  // Seller Management ("My Listings")
  List<Property> get myListings => _properties
      .where((p) => p.agent.id == 'user_agent' || p.id.startsWith('user_prop_') || p.id.startsWith('prop_custom_') || p.agent.name == userName)
      .toList();

  void updatePropertyPrice(String propertyId, double newPrice) {
    final idx = _properties.indexWhere((p) => p.id == propertyId);
    if (idx != -1) {
      _properties[idx] = _properties[idx].copyWith(price: newPrice);
      _storageService.saveCustomProperties(myListings);
      notifyListeners();
    }
  }

  void updatePropertyStatus(String propertyId, String newStatus) {
    final idx = _properties.indexWhere((p) => p.id == propertyId);
    if (idx != -1) {
      _properties[idx] = _properties[idx].copyWith(status: newStatus);
      _storageService.saveCustomProperties(myListings);
      notifyListeners();
    }
  }

  void deleteProperty(String propertyId) {
    _properties.removeWhere((p) => p.id == propertyId);
    _favoriteIds.remove(propertyId);
    _storageService.saveCustomProperties(myListings);
    _storageService.saveFavoriteIds(_favoriteIds);
    notifyListeners();
  }

  // Property Comparison List
  List<String> _compareIds = [];
  List<String> get compareIds => _compareIds;

  List<Property> get compareProperties =>
      properties.where((p) => _compareIds.contains(p.id)).toList();

  bool isInCompare(String id) => _compareIds.contains(id);

  void toggleCompare(String id) {
    if (_compareIds.contains(id)) {
      _compareIds.remove(id);
    } else {
      if (_compareIds.length >= 3) {
        _compareIds.removeAt(0);
      }
      _compareIds.add(id);
    }
    _storageService.saveCompareIds(_compareIds);
    notifyListeners();
  }

  void clearCompare() {
    _compareIds.clear();
    _storageService.saveCompareIds(_compareIds);
    notifyListeners();
  }

  // Active filters
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  PropertyType? _selectedTypeFilter;
  PropertyType? get selectedTypeFilter => _selectedTypeFilter;

  RangeValues _priceRange = const RangeValues(0, 3000000);
  RangeValues get priceRange => _priceRange;

  int _minBedrooms = 0;
  int get minBedrooms => _minBedrooms;

  int _minBathrooms = 0;
  int get minBathrooms => _minBathrooms;

  bool? _filterForRent; // null = all, true = rent, false = sale
  bool? get filterForRent => _filterForRent;

  PropertySortOption _sortOption = PropertySortOption.recommended;
  PropertySortOption get sortOption => _sortOption;

  // Scheduled Tours
  List<ScheduledTour> _scheduledTours = [];
  List<ScheduledTour> get scheduledTours => _scheduledTours;

  // Chats
  List<ChatConversation> _conversations = [];
  List<ChatConversation> get conversations =>
      _conversations.isNotEmpty ? _conversations : _chatService.currentConversations;

  // Notifications
  List<AppNotification> _notifications = [];
  List<AppNotification> get notifications =>
      _notifications.isNotEmpty ? _notifications : _notificationService.currentNotifications;

  // User Profile & Preferences
  String userName = 'Alexander Wright';
  String userEmail = 'alex.wright@luxeylin.com';
  String userPhone = '+1 (555) 887-3210';
  String userLocation = 'Los Angeles, CA';
  String? userAvatarUrl = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150';
  bool notificationsEnabled = true;
  bool isDarkMode = false;

  static const List<String> availableLocations = [
    'Los Angeles, CA',
    'New York, NY',
    'Miami, FL',
    'Seattle, WA',
    'San Francisco, CA',
  ];

  AppState() {
    _initData();
  }

  void _initData() {
    _properties = List<Property>.from(MockData.properties);
    _favoriteIds = {'prop_1', 'prop_3'};
    _scheduledTours = [
      ScheduledTour(
        id: 'tour_1',
        property: _properties.isNotEmpty ? _properties.first : MockData.properties.first,
        date: DateTime.now().add(const Duration(days: 2)),
        timeSlot: '11:00 AM',
        tourType: 'In-Person Tour',
      ),
    ];
    _conversations = List<ChatConversation>.from(MockData.initialConversations);
    _notifications = List<AppNotification>.from(MockData.initialNotifications);

    // Initial default user
    _currentUser = UserModel(
      id: 'alex_wright_01',
      name: userName,
      email: userEmail,
      phone: userPhone,
      location: userLocation,
      avatarUrl: userAvatarUrl,
      authProvider: 'email',
      createdAt: DateTime.now(),
    );

    // Asynchronously load persistent storage
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    try {
      await _storageService.init();

      // Load favorites
      final savedFavs = _storageService.getFavoriteIds();
      if (savedFavs.isNotEmpty) {
        _favoriteIds = savedFavs;
      }

      // Load custom properties
      final customProps = _storageService.getCustomProperties();
      for (final p in customProps) {
        if (!_properties.any((existing) => existing.id == p.id)) {
          _properties.insert(0, p);
        }
      }

      // Load tours
      final savedTourData = _storageService.getScheduledTours();
      if (savedTourData.isNotEmpty) {
        _scheduledTours = savedTourData.map((t) => ScheduledTour.fromJson(t)).toList();
      }

      // Load compare IDs
      _compareIds = _storageService.getCompareIds();

      // Load profile
      final savedUser = _storageService.getUserProfile();
      if (savedUser != null) {
        _applyAuthenticatedUser(savedUser);
      }

      // Load dark mode
      final savedDark = _storageService.getDarkMode();
      if (savedDark != null) {
        isDarkMode = savedDark;
      }

      notifyListeners();
    } catch (_) {}
  }

  // =============================================================
  // AUTHENTICATION APIs
  // =============================================================

  Future<ApiResponse<UserModel>> signInWithEmail(String email, String password) async {
    _isAuthLoading = true;
    _authError = null;
    notifyListeners();

    final response = await _authService.signInWithEmail(email: email, password: password);
    _isAuthLoading = false;

    if (response.success && response.data != null) {
      _applyAuthenticatedUser(response.data!);
    } else {
      _authError = response.error;
    }
    notifyListeners();
    return response;
  }

  Future<ApiResponse<UserModel>> signInWithGoogle({GoogleAccountOption? selectedAccount}) async {
    _isAuthLoading = true;
    _authError = null;
    notifyListeners();

    final response = await _authService.signInWithGoogle(selectedAccount: selectedAccount);
    _isAuthLoading = false;

    if (response.success && response.data != null) {
      _applyAuthenticatedUser(response.data!);
    } else {
      _authError = response.error;
    }
    notifyListeners();
    return response;
  }

  Future<ApiResponse<UserModel>> signInWithApple() async {
    _isAuthLoading = true;
    _authError = null;
    notifyListeners();

    final response = await _authService.signInWithApple();
    _isAuthLoading = false;

    if (response.success && response.data != null) {
      _applyAuthenticatedUser(response.data!);
    } else {
      _authError = response.error;
    }
    notifyListeners();
    return response;
  }

  Future<ApiResponse<UserModel>> signInAsGuest() async {
    _isAuthLoading = true;
    _authError = null;
    notifyListeners();

    final response = await _authService.signInAsGuest();
    _isAuthLoading = false;

    if (response.success && response.data != null) {
      _applyAuthenticatedUser(response.data!);
    } else {
      _authError = response.error;
    }
    notifyListeners();
    return response;
  }

  Future<ApiResponse<UserModel>> signUp({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    _isAuthLoading = true;
    _authError = null;
    notifyListeners();

    final response = await _authService.signUp(
      name: name,
      email: email,
      password: password,
      phone: phone,
    );
    _isAuthLoading = false;

    if (response.success && response.data != null) {
      _applyAuthenticatedUser(response.data!);
    } else {
      _authError = response.error;
    }
    notifyListeners();
    return response;
  }

  Future<ApiResponse<bool>> sendPasswordResetEmail(String email) async {
    _isAuthLoading = true;
    _authError = null;
    notifyListeners();

    final response = await _authService.sendPasswordResetEmail(email);
    _isAuthLoading = false;
    _authError = response.error;
    notifyListeners();
    return response;
  }

  Future<ApiResponse<bool>> verifyResetCode(String email, String code) async {
    _isAuthLoading = true;
    notifyListeners();

    final response = await _authService.verifyResetCode(email, code);
    _isAuthLoading = false;
    notifyListeners();
    return response;
  }

  Future<ApiResponse<bool>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    _isAuthLoading = true;
    notifyListeners();

    final response = await _authService.resetPassword(
      email: email,
      code: code,
      newPassword: newPassword,
    );
    _isAuthLoading = false;
    notifyListeners();
    return response;
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _currentUser = null;
    notifyListeners();
  }

  void _applyAuthenticatedUser(UserModel user) {
    _currentUser = user;
    userName = user.name;
    userEmail = user.email;
    if (user.phone != null) userPhone = user.phone!;
    if (user.location != null) userLocation = user.location!;
    userAvatarUrl = user.avatarUrl;
  }

  // =============================================================
  // SEARCH & FILTER METHODS
  // =============================================================

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setTypeFilter(PropertyType? type) {
    _selectedTypeFilter = type;
    notifyListeners();
  }

  void setPriceRange(RangeValues range) {
    _priceRange = range;
    notifyListeners();
  }

  void setMinBedrooms(int beds) {
    _minBedrooms = beds;
    notifyListeners();
  }

  void setMinBathrooms(int baths) {
    _minBathrooms = baths;
    notifyListeners();
  }

  void setFilterForRent(bool? forRent) {
    _filterForRent = forRent;
    notifyListeners();
  }

  void setSortOption(PropertySortOption option) {
    _sortOption = option;
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedTypeFilter = null;
    _priceRange = const RangeValues(0, 3000000);
    _minBedrooms = 0;
    _minBathrooms = 0;
    _filterForRent = null;
    _sortOption = PropertySortOption.recommended;
    notifyListeners();
  }

  List<Property> get filteredProperties {
    final list = properties;
    var result = list.where((prop) {
      if (_searchQuery.trim().isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesTitle = prop.title.toLowerCase().contains(q);
        final matchesAddress = prop.address.toLowerCase().contains(q);
        final matchesCity = prop.city.toLowerCase().contains(q);
        final matchesType = prop.type.displayName.toLowerCase().contains(q);
        if (!matchesTitle && !matchesAddress && !matchesCity && !matchesType) {
          return false;
        }
      }

      if (_selectedTypeFilter != null && prop.type != _selectedTypeFilter) {
        return false;
      }

      if (_filterForRent != null && prop.isForRent != _filterForRent) {
        return false;
      }

      if (prop.price < _priceRange.start || prop.price > _priceRange.end) {
        return false;
      }

      if (_minBedrooms > 0 && prop.bedrooms < _minBedrooms) {
        return false;
      }

      if (_minBathrooms > 0 && prop.bathrooms < _minBathrooms) {
        return false;
      }

      return true;
    }).toList();

    switch (_sortOption) {
      case PropertySortOption.priceLowToHigh:
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
      case PropertySortOption.priceHighToLow:
        result.sort((a, b) => b.price.compareTo(a.price));
        break;
      case PropertySortOption.topRated:
        result.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case PropertySortOption.recommended:
        break;
    }

    return result;
  }

  // =============================================================
  // SCHEDULED TOURS
  // =============================================================

  void addScheduledTour({
    required Property property,
    required DateTime date,
    required String timeSlot,
    required String tourType,
  }) {
    final newTour = ScheduledTour(
      id: 'tour_${DateTime.now().millisecondsSinceEpoch}',
      property: property,
      date: date,
      timeSlot: timeSlot,
      tourType: tourType,
    );
    _scheduledTours.add(newTour);

    final notif = AppNotification(
      id: 'notif_tour_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Tour Booked ✨',
      message: 'Your $tourType for ${property.title} is scheduled for ${date.day}/${date.month} at $timeSlot.',
      timestamp: DateTime.now(),
      type: NotificationType.tour,
      propertyId: property.id,
    );
    _notifications.insert(0, notif);
    _notificationService.addNotification(notif);
    _storageService.saveScheduledTours(_scheduledTours.map((t) => t.toJson()).toList());

    notifyListeners();
  }

  void cancelTour(String tourId) {
    _scheduledTours.removeWhere((t) => t.id == tourId);
    _storageService.saveScheduledTours(_scheduledTours.map((t) => t.toJson()).toList());
    notifyListeners();
  }

  // =============================================================
  // CHATS
  // =============================================================

  int get totalUnreadMessages =>
      conversations.fold(0, (sum, conv) => sum + conv.unreadCount);

  ChatConversation getOrCreateConversationForProperty(Property property) {
    final conv = _chatService.getOrCreateConversationForProperty(property);
    _conversations = List<ChatConversation>.from(_chatService.currentConversations);
    notifyListeners();
    return conv;
  }

  ChatConversation getOrCreateConversationForAgent(Agent agent) {
    final conv = _chatService.getOrCreateConversationForAgent(agent);
    _conversations = List<ChatConversation>.from(_chatService.currentConversations);
    notifyListeners();
    return conv;
  }

  void sendMessage(String conversationId, String text) {
    _chatService.sendMessage(conversationId, text);
    _conversations = List<ChatConversation>.from(_chatService.currentConversations);
    notifyListeners();

    // Auto agent reply
    Future.delayed(const Duration(milliseconds: 1200), () {
      final replyIndex = _conversations.indexWhere((c) => c.id == conversationId);
      if (replyIndex == -1) return;

      final currentConv = _conversations[replyIndex];
      final autoReplies = [
        'Thanks for reaching out! I will look into this and get back to you shortly.',
        'I would love to help you with that! Are you available for a quick phone call today?',
        'Great question! That property has high interest, so scheduling a tour early is recommended.',
      ];
      final autoReplyText = autoReplies[DateTime.now().second % autoReplies.length];

      final withReply = List<MessageItem>.from(currentConv.messages)
        ..add(
          MessageItem(
            id: 'reply_${DateTime.now().millisecondsSinceEpoch}',
            senderId: currentConv.agentId,
            text: autoReplyText,
            timestamp: DateTime.now(),
            isFromMe: false,
          ),
        );

      _conversations[replyIndex] = currentConv.copyWith(messages: withReply);
      notifyListeners();
    });
  }

  void markConversationAsRead(String conversationId) {
    _chatService.markAsRead(conversationId);
    _conversations = List<ChatConversation>.from(_chatService.currentConversations);
    notifyListeners();
  }

  // =============================================================
  // NOTIFICATIONS
  // =============================================================

  int get unreadNotificationsCount =>
      notifications.where((n) => !n.isRead).length;

  void markNotificationAsRead(String notificationId) {
    _notificationService.markAsRead(notificationId);
    _notifications = List<AppNotification>.from(_notificationService.currentNotifications);
    notifyListeners();
  }

  void markAllNotificationsAsRead() {
    _notificationService.markAllAsRead();
    _notifications = List<AppNotification>.from(_notificationService.currentNotifications);
    notifyListeners();
  }

  void clearNotifications() {
    _notificationService.clearAll();
    _notifications.clear();
    notifyListeners();
  }

  // =============================================================
  // USER PROFILE & PREFERENCES
  // =============================================================

  void setLocation(String newLocation) {
    userLocation = newLocation;
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(location: newLocation);
    }
    notifyListeners();
  }

  void updateUserProfile({
    String? name,
    String? email,
    String? phone,
    String? location,
    String? avatarUrl,
  }) {
    if (name != null && name.isNotEmpty) userName = name;
    if (email != null && email.isNotEmpty) userEmail = email;
    if (phone != null && phone.isNotEmpty) userPhone = phone;
    if (location != null && location.isNotEmpty) userLocation = location;
    if (avatarUrl != null) userAvatarUrl = avatarUrl;

    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        name: name,
        email: email,
        phone: phone,
        location: location,
        avatarUrl: avatarUrl,
      );
      _storageService.saveUserProfile(_currentUser!);
    }
    notifyListeners();
  }

  void toggleNotifications(bool val) {
    notificationsEnabled = val;
    notifyListeners();
  }

  void toggleTheme(bool val) {
    isDarkMode = val;
    _storageService.saveDarkMode(val);
    notifyListeners();
  }
}

// InheritedNotifier Provider
class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    super.key,
    required AppState super.notifier,
    required super.child,
  });

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    if (scope?.notifier != null) {
      return scope!.notifier!;
    }
    return AppState();
  }
}
