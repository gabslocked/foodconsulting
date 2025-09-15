import 'dart:async';
import 'package:flutter/material.dart';

import '../../../data/repositories/notification_repository.dart';
import '../../../data/models/notification_model.dart';
import '../../data/services/supabase_service.dart';

class UserProvider extends ChangeNotifier {
  final NotificationRepository _notificationRepository = NotificationRepository();
  
  List<NotificationModel> _notifications = [];
  int _unreadNotificationCount = 0;
  bool _isLoadingNotifications = false;
  String? _error;
  
  StreamSubscription? _notificationSubscription;
  
  // Getters
  List<NotificationModel> get notifications => _notifications;
  int get unreadNotificationCount => _unreadNotificationCount;
  bool get isLoadingNotifications => _isLoadingNotifications;
  String? get error => _error;
  
  UserProvider() {
    _initializeNotifications();
  }
  
  void _initializeNotifications() {
    // Subscribe to real-time notifications
    _subscribeToNotifications();
    
    // Load initial notifications
    loadNotifications();
    loadUnreadNotificationCount();
  }
  
  // Load user notifications
  Future<void> loadNotifications({bool unreadOnly = false}) async {
    _setLoadingNotifications(true);
    _clearError();
    
    try {
      _notifications = await _notificationRepository.getUserNotifications(
        unreadOnly: unreadOnly,
      );
      _setLoadingNotifications(false);
    } catch (e) {
      _setError(e.toString());
      _setLoadingNotifications(false);
    }
  }
  
  // Load unread notification count
  Future<void> loadUnreadNotificationCount() async {
    try {
      _unreadNotificationCount = await _notificationRepository.getUnreadCount();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading unread notification count: $e');
    }
  }
  
  // Mark notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _notificationRepository.markNotificationAsRead(notificationId);
      
      // Update local state
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(
          read: true,
          readAt: DateTime.now(),
        );
      }
      
      // Update unread count
      if (_unreadNotificationCount > 0) {
        _unreadNotificationCount--;
      }
      
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }
  
  // Mark all notifications as read
  Future<void> markAllNotificationsAsRead() async {
    try {
      await _notificationRepository.markAllNotificationsAsRead();
      
      // Update local state
      _notifications = _notifications.map((notification) => notification.copyWith(
        read: true,
        readAt: DateTime.now(),
      )).toList();
      
      _unreadNotificationCount = 0;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }
  
  // Subscribe to real-time notifications
  void _subscribeToNotifications() {
    final userId = SupabaseService.currentUser?.id;
    if (userId == null) return;
    
    _notificationSubscription?.cancel();
    
    _notificationSubscription = SupabaseService.client
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .listen((List<Map<String, dynamic>> data) {
          // Handle new notifications
          for (var notificationData in data) {
            final notification = NotificationModel.fromJson(notificationData);
            final existingIndex = _notifications.indexWhere(
              (n) => n.id == notification.id
            );
            
            if (existingIndex == -1) {
              // New notification
              _notifications.insert(0, notification);
              if (!notification.read) {
                _unreadNotificationCount++;
              }
            } else {
              // Updated notification
              final wasUnread = !_notifications[existingIndex].read;
              final isUnread = !notification.read;
              
              _notifications[existingIndex] = notification;
              
              if (wasUnread && !isUnread) {
                _unreadNotificationCount--;
              } else if (!wasUnread && isUnread) {
                _unreadNotificationCount++;
              }
            }
          }
          
          // Sort notifications by creation date
          _notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          
          notifyListeners();
        });
  }
  
  // Refresh notifications
  Future<void> refreshNotifications() async {
    await Future.wait([
      loadNotifications(),
      loadUnreadNotificationCount(),
    ]);
  }
  
  void _setLoadingNotifications(bool loading) {
    _isLoadingNotifications = loading;
    notifyListeners();
  }
  
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }
  
  void _clearError() {
    _error = null;
    notifyListeners();
  }
  
  void clearError() {
    _clearError();
  }
  
  @override
  void dispose() {
    _notificationSubscription?.cancel();
    super.dispose();
  }
}
