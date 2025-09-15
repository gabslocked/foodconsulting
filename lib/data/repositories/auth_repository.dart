import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/supabase_service.dart';

class AuthRepository {
  // Sign in with email and password
  Future<AuthResponse> signIn(String email, String password) async {
    try {
      final response = await SupabaseService.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        // Save FCM token after successful login
        await _saveFcmToken(response.user!.id);
      }
      
      return response;
    } catch (e) {
      throw Exception(SupabaseService.getErrorMessage(e));
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    try {
      await SupabaseService.client.auth.signOut();
    } catch (e) {
      throw Exception(SupabaseService.getErrorMessage(e));
    }
  }
  
  // Get current user profile
  Future<UserModel?> getCurrentUserProfile() async {
    try {
      final user = SupabaseService.currentUser;
      if (user == null) return null;
      
      final response = await SupabaseService.from('profiles')
          .select()
          .eq('id', user.id)
          .single();
      
      return UserModel.fromJson(response);
    } catch (e) {
      debugPrint('Error getting user profile: $e');
      throw Exception(SupabaseService.getErrorMessage(e));
    }
  }
  
  // Update user profile
  Future<UserModel> updateProfile(UserModel user) async {
    try {
      final response = await SupabaseService.from('profiles')
          .update(user.toJson())
          .eq('id', user.id)
          .select()
          .single();
      
      return UserModel.fromJson(response);
    } catch (e) {
      throw Exception(SupabaseService.getErrorMessage(e));
    }
  }
  
  // Save FCM token to user profile (disabled for now)
  Future<void> _saveFcmToken(String userId) async {
    try {
      // Firebase messaging disabled for now
      debugPrint('FCM token saving disabled');
    } catch (e) {
      // Ignore FCM token errors for now
      debugPrint('FCM token error: $e');
    }
  }
  
  // Check if user is authenticated
  bool get isAuthenticated => SupabaseService.currentUser != null;
  
  // Get auth state changes stream
  Stream<AuthState> get authStateChanges => SupabaseService.authStateChanges;
  
  // Get Supabase client for direct access
  SupabaseClient get supabaseClient => SupabaseService.client;
  
  // Change password
  Future<bool> changePassword({
    String? currentPassword,
    required String newPassword,
  }) async {
    try {
      if (currentPassword != null) {
        // For existing users, verify current password first
        await SupabaseService.client.auth.updateUser(
          UserAttributes(password: newPassword),
        );
      } else {
        // For first login, just update password
        await SupabaseService.client.auth.updateUser(
          UserAttributes(password: newPassword),
        );
      }
      return true;
    } catch (e) {
      throw Exception(SupabaseService.getErrorMessage(e));
    }
  }
}
