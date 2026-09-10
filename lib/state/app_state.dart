import 'package:flutter/material.dart';
import '../models/property_model.dart';
import '../models/chat_model.dart';
import '../models/notification_model.dart';
import '../data/mock_data.dart';

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
}

class AppState extends ChangeNotifier {
  // All properties
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
  List<ChatConversation> get conversations => _conversations.isNotEmpty ? _conversations : MockData.initialConversations;

  // Notifications
  List<AppNotification> _notifications = [];
  List<AppNotification> get notifications => _notifications.isNotEmpty ? _notifications : MockData.initialNotifications;

  // User Profile & Location
  String userName = 'Alexander Wright';
  String userEmail = 'alex.wright@luxeylin.com';
  String userPhone = '+1 (555) 887-3210';
  String userLocation = 'Los Angeles, CA';
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
  }

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
      // Query filter
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

      // Property type filter
      if (_selectedTypeFilter != null && prop.type != _selectedTypeFilter) {
        return false;
      }

      // Rent/Sale filter
      if (_filterForRent != null && prop.isForRent != _filterForRent) {
        return false;
      }

      // Price filter
      if (prop.price < _priceRange.start || prop.price > _priceRange.end) {
        return false;
      }

      // Bedrooms filter
      if (_minBedrooms > 0 && prop.bedrooms < _minBedrooms) {
        return false;
      }

      // Bathrooms filter
      if (_minBathrooms > 0 && prop.bathrooms < _minBathrooms) {
        return false;
      }

      return true;
    }).toList();

    // Sort order
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
      default:
        break;
    }

    return result;
  }

  // -------------------------------------------------------------
  // SCHEDULED TOURS
  // -------------------------------------------------------------
  void addScheduledTour({
    required Property property,
    required DateTime date,
    required String timeSlot,
    required String tourType,
  }) {
    _scheduledTours.add(
      ScheduledTour(
        id: 'tour_${DateTime.now().millisecondsSinceEpoch}',
        property: property,
        date: date,
        timeSlot: timeSlot,
        tourType: tourType,
      ),
    );

    // Add a notification for this booking
    _notifications.insert(
      0,
      AppNotification(
        id: 'notif_tour_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Tour Booked ✨',
        message: 'Your $tourType for ${property.title} is scheduled for ${date.day}/${date.month} at $timeSlot.',
        timestamp: DateTime.now(),
        type: NotificationType.tour,
        propertyId: property.id,
      ),
    );

    notifyListeners();
  }

  void cancelTour(String tourId) {
    _scheduledTours.removeWhere((t) => t.id == tourId);
    notifyListeners();
  }

  // -------------------------------------------------------------
  // CHATS
  // -------------------------------------------------------------
  int get totalUnreadMessages =>
      conversations.fold(0, (sum, conv) => sum + conv.unreadCount);

  ChatConversation getOrCreateConversationForProperty(Property property) {
    final convList = conversations;
    final existingIndex = convList.indexWhere(
      (c) => c.agentId == property.agent.id,
    );

    if (existingIndex != -1) {
      return convList[existingIndex];
    }

    final newConv = ChatConversation(
      id: 'chat_${DateTime.now().millisecondsSinceEpoch}',
      agentId: property.agent.id,
      agentName: property.agent.name,
      agentAvatar: property.agent.avatarUrl,
      propertyTitle: property.title,
      propertyThumbnail: property.images.isNotEmpty ? property.images.first : '',
      unreadCount: 0,
      messages: [
        MessageItem(
          id: 'welcome_${DateTime.now().millisecondsSinceEpoch}',
          senderId: property.agent.id,
          text: 'Hi! I am ${property.agent.name}. How can I assist you with ${property.title}?',
          timestamp: DateTime.now(),
          isFromMe: false,
        ),
      ],
    );
    _conversations.insert(0, newConv);
    notifyListeners();
    return newConv;
  }

  void sendMessage(String conversationId, String text) {
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index == -1) return;

    final conv = _conversations[index];
    final updatedMessages = List<MessageItem>.from(conv.messages)
      ..add(
        MessageItem(
          id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
          senderId: 'user',
          text: text,
          timestamp: DateTime.now(),
          isFromMe: true,
        ),
      );

    _conversations[index] = conv.copyWith(messages: updatedMessages);
    notifyListeners();

    // Trigger simulated agent response after 1.5 seconds
    Future.delayed(const Duration(milliseconds: 1500), () {
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
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1 && _conversations[index].unreadCount > 0) {
      _conversations[index] = _conversations[index].copyWith(unreadCount: 0);
      notifyListeners();
    }
  }

  // -------------------------------------------------------------
  // NOTIFICATIONS
  // -------------------------------------------------------------
  int get unreadNotificationsCount =>
      notifications.where((n) => !n.isRead).length;

  void markNotificationAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void markAllNotificationsAsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    }
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  // -------------------------------------------------------------
  // USER PROFILE & LOCATION
  // -------------------------------------------------------------
  void setLocation(String newLocation) {
    userLocation = newLocation;
    notifyListeners();
  }

  void updateUserProfile({
    String? name,
    String? email,
    String? phone,
    String? location,
  }) {
    if (name != null && name.isNotEmpty) userName = name;
    if (email != null && email.isNotEmpty) userEmail = email;
    if (phone != null && phone.isNotEmpty) userPhone = phone;
    if (location != null && location.isNotEmpty) userLocation = location;
    notifyListeners();
  }

  void toggleNotifications(bool val) {
    notificationsEnabled = val;
    notifyListeners();
  }

  void toggleTheme(bool val) {
    isDarkMode = val;
    notifyListeners();
  }
}

// InheritedNotifier Provider for direct and reactive access
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
