import 'package:flutter/material.dart';
import 'supabase_service.dart';

class NotificationService {
  static Future<void> initialize() async {
    debugPrint('NotificationService initialized - Firebase dependencies disabled for now');
  }
  
  // Subscribe to mission-specific notifications (placeholder)
  static Future<void> subscribeToMission(String missionId) async {
    debugPrint('Subscribed to mission: $missionId');
  }
  
  static Future<void> unsubscribeFromMission(String missionId) async {
    debugPrint('Unsubscribed from mission: $missionId');
  }
}
