import 'dart:async';
import '../models/notification_model.dart';
import '../data/mock_data.dart';
import 'api_response.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal() {
    _notifications = List<AppNotification>.from(MockData.initialNotifications);
  }

  List<AppNotification> _notifications = [];

  Future<ApiResponse<List<AppNotification>>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return ApiResponse.success(List.unmodifiable(_notifications));
  }

  void addNotification(AppNotification notif) {
    _notifications.insert(0, notif);
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }

  void markAllAsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    }
  }

  void clearAll() {
    _notifications.clear();
  }

  List<AppNotification> get currentNotifications => List.unmodifiable(_notifications);
}
