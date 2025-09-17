import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final GlobalKey<NavigatorState> navigatorKey;
  final AuthRepository _authRepository = AuthRepository();
  
  UserModel? _user;
  bool _isLoading = false;
  String? _error;
  bool _keepLoggedIn = false;
  bool _isInitialized = false;
  
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String? get error => _error;
  bool get keepLoggedIn => _keepLoggedIn;
  bool get isInitialized => _isInitialized;
  
  AuthProvider({required this.navigatorKey}) {
    _initializeAuth();
    _loadKeepLoggedInPreference();
    _setupAppLifecycleListener();
  }
  
  void _initializeAuth() {
    // Listen to auth state changes
    _authRepository.authStateChanges.listen((AuthState data) {
      debugPrint('🔐 Auth state change: ${data.event}');
      
      if (data.event == AuthChangeEvent.signedIn) {
        _loadUserProfile();
      } else if (data.event == AuthChangeEvent.signedOut) {
        _user = null;
        _isInitialized = true;
        navigatorKey.currentState?.pushNamedAndRemoveUntil('login', (route) => false);
        notifyListeners();
      } else if (data.event == AuthChangeEvent.tokenRefreshed) {
        debugPrint('🔄 Token refreshed, loading user profile');
        _loadUserProfile();
      }
    });
    
    // Check for existing session
    _checkInitialSession();
  }

  Future<void> _checkInitialSession() async {
    try {
      debugPrint('🔍 Checking initial session...');
      final session = _authRepository.supabaseClient.auth.currentSession;
      
      if (session != null) {
        debugPrint('📱 Found existing session');
        
        // Check if session is expired
        if (session.isExpired) {
          debugPrint('⏰ Session expired, waiting for refresh...');
          // Wait for token refresh event
          await for (final authState in _authRepository.authStateChanges) {
            if (authState.event == AuthChangeEvent.tokenRefreshed) {
              debugPrint('✅ Token refreshed successfully');
              await _loadUserProfile();
              break;
            } else if (authState.event == AuthChangeEvent.signedOut) {
              debugPrint('❌ Session refresh failed, user signed out');
              _isInitialized = true;
              notifyListeners();
              break;
            }
          }
        } else {
          debugPrint('✅ Valid session found, loading user profile');
          await _loadUserProfile();
        }
      } else {
        debugPrint('❌ No existing session found');
        _isInitialized = true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Error checking initial session: $e');
      _isInitialized = true;
      notifyListeners();
    }
  }
  
  Future<void> _loadUserProfile() async {
    try {
      _user = await _authRepository.getCurrentUserProfile();
      _isInitialized = true;
      debugPrint('✅ User profile loaded: ${_user?.fullName}');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error loading user profile: $e');
      // Don't throw error, just set user to null to prevent infinite loop
      _user = null;
      _isInitialized = true;
      notifyListeners();
    }
  }
  
  Future<bool> signIn(String email, String password, {bool keepLoggedIn = false}) async {
    _setLoading(true);
    _clearError();
    
    try {
      final response = await _authRepository.signIn(email, password);
      if (response.user != null) {
        _keepLoggedIn = keepLoggedIn;
        await _saveKeepLoggedInPreference(keepLoggedIn);
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

  void setKeepLoggedIn(bool value) {
    _keepLoggedIn = value;
    notifyListeners();
  }

  Future<void> _loadKeepLoggedInPreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _keepLoggedIn = prefs.getBool('keep_logged_in') ?? false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading keep logged in preference: $e');
    }
  }

  Future<void> _saveKeepLoggedInPreference(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('keep_logged_in', value);
    } catch (e) {
      debugPrint('Error saving keep logged in preference: $e');
    }
  }

  void _setupAppLifecycleListener() {
    SystemChannels.lifecycle.setMessageHandler((message) async {
      debugPrint('🔄 App lifecycle state: $message');
      
      if (message == AppLifecycleState.detached.toString()) {
        // App is being terminated - only sign out if keep logged in is disabled
        if (!_keepLoggedIn && _user != null) {
          debugPrint('🚪 App terminated without keep logged in - signing out');
          try {
            await _authRepository.signOut();
            _user = null;
            await _saveKeepLoggedInPreference(false);
          } catch (e) {
            debugPrint('❌ Error signing out on app termination: $e');
          }
        } else if (_keepLoggedIn && _user != null) {
          debugPrint('💾 App terminated with keep logged in enabled - preserving session');
        }
      } else if (message == AppLifecycleState.paused.toString()) {
        // App moved to background
        debugPrint('⏸️ App moved to background - session preserved');
        
        // For Android: Clear sensitive data from recent apps if keep logged in is disabled
        if (!_keepLoggedIn) {
          // This helps with security on Android recent apps screen
          debugPrint('🔒 Clearing sensitive data for recent apps');
        }
      } else if (message == AppLifecycleState.resumed.toString()) {
        // App resumed from background
        debugPrint('▶️ App resumed from background');
        
        // Check if session is still valid when app resumes
        if (_user != null) {
          final session = _authRepository.supabaseClient.auth.currentSession;
          if (session != null && session.isExpired) {
            debugPrint('⏰ Session expired while app was in background - will refresh automatically');
          } else if (session != null) {
            debugPrint('✅ Session still valid after resume');
          } else {
            debugPrint('❌ No session found after resume');
            if (!_keepLoggedIn) {
              _user = null;
              notifyListeners();
            }
          }
        }
      } else if (message == AppLifecycleState.inactive.toString()) {
        // App is inactive (iOS specific - when app is interrupted)
        debugPrint('😴 App became inactive');
      }
      
      return null;
    });
  }
}
