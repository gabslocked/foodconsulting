import 'package:flutter/material.dart';

class AppColors {
  // Food Consulting Brand Colors
  static const Color primary = Color(0xFF003E71);      // Indigo Dye - Primary brand color
  static const Color secondary = Color(0xFF8F0E34);    // Claret - Secondary brand color
  static const Color accent = Color(0xFFE9B93A);       // Saffron - Accent/highlight color
  
  // Brand Color Variations
  static const Color primaryLight = Color(0xFF1A5490);
  static const Color primaryDark = Color(0xFF002A4F);
  static const Color secondaryLight = Color(0xFFA8234A);
  static const Color secondaryDark = Color(0xFF6B0A28);
  static const Color accentLight = Color(0xFFEDC555);
  static const Color accentDark = Color(0xFFD4A429);
  
  // Background Colors
  static const Color background = Color(0xFFFFFFFF);    // Pure white background
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF9FAFB);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF003E71);   // Primary brand color for headings
  static const Color textSecondary = Color(0xFF6B7280); // Medium gray for body text
  static const Color textOnPrimary = Colors.white;      // White text on primary background
  static const Color textOnAccent = Color(0xFF003E71);  // Primary color text on accent background
  
  // Status Colors (keeping functional colors)
  static const Color success = Color(0xFF10B981);       // Green
  static const Color warning = Color(0xFFE9B93A);       // Using brand saffron for warnings
  static const Color error = Color(0xFF8F0E34);         // Using brand claret for errors
  static const Color info = Color(0xFF003E71);          // Using brand primary for info
  
  // Neutral Colors (keeping existing grays)
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);
}
