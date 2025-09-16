import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final GlobalKey<NavigatorState> navigatorKey;
  final AuthRepository _authRepository = AuthRepository();
  
  UserModel? _user;
  bool _isLoading = false;
  String? _error;
  
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String? get error => _error;
  
  AuthProvider({required this.navigatorKey}) {
    _initializeAuth();
  }
  
  void _initializeAuth() {
    // Listen to auth state changes
    _authRepository.authStateChanges.listen((AuthState data) {
      if (data.event == AuthChangeEvent.signedIn) {
        _loadUserProfile();
      } else if (data.event == AuthChangeEvent.signedOut) {
        _user = null;
        navigatorKey.currentState?.pushNamedAndRemoveUntil('login', (route) => false);
        notifyListeners();
      }
    });
    
    // Load user profile if already authenticated
    if (_authRepository.isAuthenticated) {
      _loadUserProfile();
    }
  }
  
  Future<void> _loadUserProfile() async {
    try {
      _user = await _authRepository.getCurrentUserProfile();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading user profile: $e');
      // Don't throw error, just set user to null to prevent infinite loop
      _user = null;
      notifyListeners();
    }
  }
  
  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _clearError();
    
    try {
      final response = await _authRepository.signIn(email, password);
      if (response.user != null) {
        await _loadUserProfile();
        _setLoading(false);
        return true;
      }
      _setLoading(false);
      return false;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }
  
  Future<void> signOut() async {
    _setLoading(true);
    
    try {
      await _authRepository.signOut();
      _user = null;
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }
  
  Future<bool> updateProfile({
    String? fullName,
    String? phone,
    String? company,
    String? role,
    String? avatarUrl,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      if (_user != null) {
        final updatedUser = UserModel(
          id: _user!.id,
          email: _user!.email,
          fullName: fullName ?? _user!.fullName,
          phone: phone ?? _user!.phone,
          company: company ?? _user!.company,
          role: role ?? _user!.role,
          avatarUrl: avatarUrl ?? _user!.avatarUrl,
          createdAt: _user!.createdAt,
          updatedAt: DateTime.now(),
        );
        
        _user = await _authRepository.updateProfile(updatedUser);
        _setLoading(false);
        notifyListeners();
        return true;
      }
      _setLoading(false);
      return false;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }
  
  SupabaseClient get supabaseClient => _authRepository.supabaseClient;
  
  Future<bool> changePassword({
    String? currentPassword,
    required String newPassword,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final success = await _authRepository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      _setLoading(false);
      return success;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }
  
  Future<bool> markFirstLoginCompleted() async {
    _setLoading(true);
    _clearError();
    
    try {
      if (_user != null) {
        final updatedUser = _user!.copyWith(
          isFirstLogin: false,
          updatedAt: DateTime.now(),
        );
        
        _user = await _authRepository.updateProfile(updatedUser);
        _setLoading(false);
        notifyListeners();
        return true;
      }
      _setLoading(false);
      return false;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }
  
  void _setLoading(bool loading) {
    _isLoading = loading;
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
}
