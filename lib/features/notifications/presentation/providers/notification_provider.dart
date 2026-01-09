import 'package:flutter/material.dart';
import 'package:pms/features/notifications/data/models/notification_model.dart';
import 'package:pms/features/notifications/data/repositories/notification_repository.dart';
import 'package:pms/core/network/api_error_handler.dart';

class NotificationProvider extends ChangeNotifier {
  NotificationRepository _notificationRepository;
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  String? _errorMessage;

  NotificationProvider(this._notificationRepository);

  void updateRepo(NotificationRepository repo) {
    _notificationRepository = repo;
  }

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  Future<void> loadNotifications() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _notifications = await _notificationRepository.getNotifications();
    } catch (e) {
      _errorMessage = ApiErrorHandler.handleErrorMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _notificationRepository.markAsRead(notificationId);
      
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1 && !_notifications[index].isRead) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
        notifyListeners();
      }
    } catch (e) {
      // Semi-silent failure for UX
      debugPrint("Failed to mark as read: $e");
    }
  }

  void markAllAsRead() {
    // In a real app, this would also be an API call
    _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    notifyListeners();
  }

  void clearAll() {
    _notifications = [];
    notifyListeners();
  }
}
