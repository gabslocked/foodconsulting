import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../presentation/providers/auth_provider.dart';
import '../presentation/screens/splash/splash_screen.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/profile_screen.dart';
import '../presentation/screens/auth/change_password_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/mission/mission_detail_screen.dart';
import '../presentation/screens/notifications/notifications_screen.dart';

class AppRouter {
  static GoRouter router(GlobalKey<NavigatorState> navigatorKey) {
    return GoRouter(
      navigatorKey: navigatorKey,
    initialLocation: '/',
    redirect: (BuildContext context, GoRouterState state) {
      final authProvider = context.read<AuthProvider>();
      final isAuthenticated = authProvider.isAuthenticated;
      final isLoading = authProvider.isLoading;
      
      // Show splash while loading
      if (isLoading) {
        return '/';
      }
      
      // Redirect to login if not authenticated
      if (!isAuthenticated && state.uri.toString() != '/login') {
        return '/login';
      }
      
      // Redirect to home if authenticated and on login/splash
      if (isAuthenticated) {
        final user = authProvider.user;
        
        // Check if it's first login and redirect to change password
        if (user?.isFirstLogin == true && !state.uri.toString().contains('/change-password')) {
          return '/change-password?first=true';
        }
        
        if (state.uri.toString() == '/login' || state.uri.toString() == '/') {
          return '/home';
        }
      }
      
      return null;
    },
    routes: [
      // Splash Screen
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      
      // Authentication Routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      
      // Home Route
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          // Profile Route
          GoRoute(
            path: 'profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          
          // Notifications Route
          GoRoute(
            path: 'notifications',
            name: 'notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
        ],
      ),
      
      // Profile Route (standalone)
      GoRoute(
        path: '/profile',
        name: 'profile-standalone',
        builder: (context, state) => const ProfileScreen(),
      ),
      
      // Change Password Route
      GoRoute(
        path: '/change-password',
        name: 'change-password',
        builder: (context, state) {
          final isFirstLogin = state.uri.queryParameters['first'] == 'true';
          return ChangePasswordScreen(isFirstLogin: isFirstLogin);
        },
      ),
      
      // Mission Detail Route
      GoRoute(
        path: '/mission/:id',
        name: 'mission-detail',
        builder: (context, state) {
          final missionId = state.pathParameters['id']!;
          final initialTab = state.uri.queryParameters['tab'];
          return MissionDetailScreen(
            missionId: missionId,
          );
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Erro')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Página não encontrada',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'A página "${state.uri.toString()}" não existe.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Voltar ao Início'),
            ),
          ],
        ),
      ),
    ),
  );
  }
}
