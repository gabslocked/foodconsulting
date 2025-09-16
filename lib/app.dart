import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'main.dart';

import 'core/config/theme_config.dart';
import 'routes/app_router.dart';

class FoodConsultingApp extends StatelessWidget {
  const FoodConsultingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Food Consulting',
      theme: ThemeConfig.lightTheme,
      darkTheme: ThemeConfig.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: AppRouter.router(navigatorKey),
      debugShowCheckedModeBanner: false,
    );
  }
}
