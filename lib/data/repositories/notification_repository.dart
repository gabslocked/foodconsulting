import '../services/supabase_service.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  // Get user notifications
  Future<List<NotificationModel>> getUserNotifications({
    bool? unreadOnly,
    int limit = 20,
  }) async {
    try {
      final userId = SupabaseService.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');
      
      // Return empty list if notifications table doesn't exist
      try {
        var query = SupabaseService.client
            .from('notifications')
            .select()
            .eq('user_id', userId);
        
        if (unreadOnly == true) {
          query = query.eq('read', false);
        }
        
        final response = await query
            .order('created_at', ascending: false)
            .limit(limit);
        
        return (response as List)
            .map((json) => NotificationModel.fromJson(json))
            .toList();
      } catch (tableError) {
        // If table doesn't exist, return empty list instead of throwing error
        if (tableError.toString().contains('relation "public.notifications" does not exist') ||
            tableError.toString().contains('notifications') && tableError.toString().contains('does not exist')) {
          return [];
        }
        rethrow;
      }
    } catch (e) {
      throw Exception(SupabaseService.getErrorMessage(e));
    }
  }
  
  // Mark notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await SupabaseService.client
          .from('notifications')
          .update({
            'read': true,
            'read_at': DateTime.now().toIso8601String(),
          })
          .eq('id', notificationId);
    } catch (e) {
      // Silently fail if table doesn't exist
      if (e.toString().contains('notifications') && e.toString().contains('does not exist')) {
        return;
      }
      throw Exception(SupabaseService.getErrorMessage(e));
    }
  }
  
  // Mark all notifications as read
  Future<void> markAllNotificationsAsRead() async {
    try {
      final userId = SupabaseService.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');
      
      await SupabaseService.client
          .from('notifications')
          .update({
            'read': true,
            'read_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId)
          .eq('read', false);
    } catch (e) {
      // Silently fail if table doesn't exist
      if (e.toString().contains('notifications') && e.toString().contains('does not exist')) {
        return;
      }
      throw Exception(SupabaseService.getErrorMessage(e));
    }
  }
  
  // Get unread notification count
  Future<int> getUnreadCount() async {
    try {
      final userId = SupabaseService.currentUser?.id;
      if (userId == null) return 0;
      
      final response = await SupabaseService.client
          .from('notifications')
          .select('id')
          .eq('user_id', userId)
          .eq('read', false);

      return (response as List).length;
    } catch (e) {
      // Return 0 if table doesn't exist
      if (e.toString().contains('notifications') && e.toString().contains('does not exist')) {
        return 0;
      }
      throw Exception('Erro ao buscar contagem de notificações: $e');
    }
  }
}
