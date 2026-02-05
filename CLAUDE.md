# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Curation** - An essay social feed app built with Flutter. The app displays articles from followed authors and interest-based recommendations in a scrollable feed. Includes Naver OAuth authentication.

## Build & Run Commands

```bash
cd code
flutter pub get
flutter run

# Run with Naver login credentials (required for auth to work)
flutter run --dart-define=NAVER_CLIENT_ID=your_id --dart-define=NAVER_CLIENT_SECRET=your_secret

# Run on specific device
flutter run -d windows
flutter run -d chrome

flutter analyze
flutter test
flutter test test/widget_test.dart
```

## Architecture

### App Startup Flow
1. `AppBootstrap.initialize()` - Initializes Flutter bindings and Naver SDK
2. `AuthNotifier.checkAuthStatus()` - Checks stored tokens, refreshes if needed
3. Routes to `LoginScreen` or `HomeScreen` based on auth state

### State Management
Uses **Riverpod** with `StateNotifier` pattern:
- `auth_provider.dart` - `AuthNotifier` manages login/logout/token refresh
- `feed_provider.dart` - `ArticlesNotifier` manages article list and feed tabs

### Authentication System
Layered architecture with dependency injection for testability:
```
providers/auth/
  auth_provider.dart       # AuthNotifier StateNotifier

services/auth/
  naver_login_service.dart      # Abstract interface
  naver_login_service_impl.dart # flutter_naver_login implementation
  secure_token_repository.dart  # Token storage via flutter_secure_storage
  naver_sdk_initializer.dart    # SDK init interface
  naver_sdk_initializer_impl.dart

models/auth/
  auth_state.dart    # AuthStatus enum + user state
  naver_tokens.dart  # Token model with expiry check
  user.dart          # User profile model

config/
  naver_config.dart  # Reads --dart-define env vars
```

### Theme System
- `app_colors.dart` - Color constants (primary: teal #24748F)
- `app_theme.dart` - Light/dark themes using Google Fonts (Manrope)
- Defaults to dark mode

### Key Patterns
- Graceful degradation: App starts even if SDK init fails
- Service abstraction: All auth services use interfaces for testing with `mocktail`
- Responsive layout: `MediaQuery` for screen height detection (`isCompact` for < 700px)
