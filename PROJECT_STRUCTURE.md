# Project Structure Guide

This document describes the organization and structure of the Listify project.

## Directory Overview

### Root Level Files
- `pubspec.yaml` - Flutter project configuration and dependencies
- `analysis_options.yaml` - Dart analyzer configuration
- `CHANGELOG.md` - Version history and updates
- `CONTRIBUTING.md` - Contributing guidelines
- `SECURITY.md` - Security policy
- `README.md` - Project overview

### `/lib` - Application Source Code

#### `/lib/config`
Configuration files for the entire application:
- **`/config/theme`** - App theme, colors, text styles, and design constants
- **`/config/routes`** - Route definitions and navigation configuration

#### `/lib/features`
Feature-specific modules using Clean Architecture:
- **`/shopping_list`** - Main shopping list feature
  - **`/data`** - Data layer (repositories, models, data sources)
  - **`/domain`** - Domain layer (entities, repositories interfaces, use cases)
  - **`/presentation`** - Presentation layer (pages, widgets, BLoC)

#### `/lib/shared`
Shared/reusable code across features:
- **`/shared/widgets`** - Reusable UI components
- **`/shared/utils`** - Utility functions and helpers
- **`/shared/constants`** - App-wide constants
- **`/shared/extensions`** - Dart extensions on built-in types

#### Root Level Files in `/lib`
- `main.dart` - App entry point
- `app.dart` - MaterialApp configuration
- `injection.dart` - Service locator (GetIt) setup

### `/test` - Unit and Widget Tests
- **`/features`** - Feature-specific tests
  - **`/shopping_list`**
    - **`/bloc`** - BLoC tests
    - **`/widgets`** - Widget tests

### `/android` - Android Native Code
- `build.gradle.kts` - Android build configuration
- `local.properties` - Local machine configuration (git ignored)
- `/app/src/` - Android app source

### `/ios` - iOS Native Code
- `Podfile` - CocoaPods configuration
- `/Runner/` - iOS app source
- `/Runner.xcworkspace/` - Xcode workspace

### `/web` - Web Platform Code
- `index.html` - Web entry point
- `manifest.json` - PWA manifest

### `/assets` - Static Resources
- `/screenshots/` - App screenshots for documentation

### `/.github` - GitHub Configuration
- **`/workflows`** - CI/CD workflow files

### `/docs` - Additional Documentation
- `INTERVIEW_GUIDE.md` - Interview preparation guide

## Architecture Pattern

The project follows **Clean Architecture** with **BLoC** for state management:

```
Presentation Layer (UI)
       ↓ (depends on)
Domain Layer (Business Logic)
       ↓ (depends on)
Data Layer (Data Management)
```

### Clean Architecture Layers

- **Presentation**: UI widgets, BLoC state management, and user interaction
- **Domain**: Business rules, entities, and use case definitions
- **Data**: Repository implementations, models, and data sources

## File Naming Conventions

- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables/Functions**: `camelCase`
- **Constants**: `camelCase`

## Dependencies

Key dependencies managed through `pubspec.yaml`:
- **State Management**: flutter_bloc
- **Local Storage**: hive_flutter
- **Dependency Injection**: get_it
- **Functional Programming**: dartz
- **Testing**: bloc_test, mocktail

## Getting Started

1. Install dependencies: `flutter pub get`
2. Generate code: `flutter pub run build_runner build`
3. Run app: `flutter run`
4. Run tests: `flutter test`

## Best Practices

1. Keep features independent and modular
2. Use dependency injection (GetIt) for managing dependencies
3. Write tests alongside features
4. Follow the Clean Architecture pattern strictly
5. Use BLoC for state management in presentation layer
6. Avoid cross-feature dependencies when possible
