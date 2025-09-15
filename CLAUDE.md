# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter application called "Food Consulting App" - a mobile app for international food consulting mission participants. It integrates with Supabase for backend services and uses Provider for state management.

## Development Commands

### Run the Application
```bash
# Run on Android device/emulator
flutter run

# Run on web (with specific port and hostname)
flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0

# Run on specific device
flutter run -d <device_id>
```

### Code Analysis and Linting
```bash
# Analyze code for errors, warnings, and lints
flutter analyze

# Format code
dart format .
```

### Testing
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

### Build Commands
```bash
# Build for Android
flutter build apk

# Build for web
flutter build web

# Generate JSON serialization code
dart run build_runner build

# Watch for changes and regenerate code
dart run build_runner watch
```

### Dependencies
```bash
# Get dependencies
flutter pub get

# Upgrade dependencies
flutter pub upgrade

# Generate launcher icons
flutter pub run flutter_launcher_icons
```

## Architecture Overview

### Directory Structure
- `lib/core/` - Core utilities, configurations, and constants
  - `config/` - Environment, Supabase, and theme configurations
  - `constants/` - App colors, strings, and dimensions
  - `utils/` - Date formatters, currency formatters, validators
- `lib/data/` - Data layer with repositories, models, and services
  - `models/` - JSON serializable data models (with .g.dart generated files)
  - `repositories/` - Data access layer abstractions
  - `services/` - Concrete service implementations (Supabase, storage, notifications)
- `lib/presentation/` - UI layer
  - `screens/` - Complete screen implementations organized by feature
  - `widgets/` - Reusable UI components
  - `providers/` - State management using Provider pattern
- `lib/routes/` - Navigation configuration using GoRouter

### Key Technologies
- **Flutter**: Main framework
- **Supabase**: Backend-as-a-Service (authentication, PostgreSQL database, real-time subscriptions)
- **Provider**: State management
- **GoRouter**: Declarative routing
- **JSON Annotation/Serializable**: Model serialization with code generation

### Main Entry Points
- `lib/main.dart` - Production entry point with full provider setup
- `lib/main_simple.dart` - Simplified entry point for basic testing
- `lib/main_working.dart` - Development entry point
- `lib/main_supabase.dart` - Full Supabase integration testing

### Database Schema (Supabase/PostgreSQL)
Key tables include:
- `profiles` - User profiles
- `missions` - Food consulting missions
- `mission_participants` - Mission participation records
- `flights`, `accommodations`, `itineraries` - Mission logistics
- `activities`, `tips` - Mission content
- `notifications` - User notifications

### State Management Pattern
Uses Provider pattern with separate providers for:
- `AuthProvider` - Authentication state
- `MissionProvider` - Mission data and operations
- `UserProvider` - User profile management
- `NotificationProvider` - Notification handling

### Code Generation
The project uses build_runner for generating JSON serialization code. All model files have corresponding `.g.dart` files that are auto-generated. Run `dart run build_runner build` after modifying any models with `@JsonSerializable()` annotations.

### Platform Support
- ✅ Android (primary target)
- ✅ Web (PWA-capable)
- Firebase integration temporarily disabled for web compatibility

### Hot Reload
- Android: Use `r` for hot reload, `R` for hot restart
- Web: Automatic in browser during development