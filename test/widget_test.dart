// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:food_consulting_app/app.dart';
import 'package:food_consulting_app/presentation/providers/auth_provider.dart';
import 'package:food_consulting_app/presentation/providers/mission_provider.dart';
import 'package:food_consulting_app/presentation/providers/user_provider.dart';

void main() {
  testWidgets('App starts correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => MissionProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
        ],
        child: const FoodConsultingApp(),
      ),
    );

    // Verify that splash screen appears
    expect(find.text('Food Consulting'), findsOneWidget);
  });
}
