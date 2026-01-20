# Development Guide

## Prerequisites

- Flutter SDK 3.7.2 or higher
- Dart 3.7.2 or higher
- Android Studio / Xcode (for native development)
- Git

## Setup Instructions

### 1. Clone the Repository
```bash
git clone https://github.com/yxshee/listify.git
cd listify
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Generate Code
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Run the Application

#### Development (Debug Mode)
```bash
flutter run
```

#### Release Mode
```bash
flutter run --release
```

#### Platform-Specific

**iOS:**
```bash
flutter run -d macos
# or
flutter run -d iphone
```

**Android:**
```bash
flutter run -d android
```

**Web:**
```bash
flutter run -d web
```

## Development Workflow

### Running Tests
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run tests for a specific file
flutter test test/features/shopping_list/bloc/shopping_list_bloc_test.dart
```

### Code Analysis
```bash
# Analyze code
dart analyze

# Fix formatting
dart format .

# Run linter
flutter analyze --no-pub
```

### Code Generation
```bash
# Watch mode for continuous code generation
flutter pub run build_runner watch
```

## Project Structure

See [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) for detailed information about the project organization.

## Clean Architecture

The project implements Clean Architecture with three main layers:

1. **Presentation Layer** - UI components and state management (BLoC)
2. **Domain Layer** - Business logic and use cases
3. **Data Layer** - Data sources and repository implementations

## BLoC Pattern

We use BLoC (Business Logic Component) for state management. Each feature has:
- `Events` - User interactions
- `States` - UI states
- `BLoC` - Business logic

Example:
```dart
// Event
class GetShoppingListsEvent extends ShoppingListEvent {}

// State
class ShoppingListLoading extends ShoppingListState {}
class ShoppingListLoaded extends ShoppingListState {
  final List<ShoppingList> lists;
  ShoppingListLoaded(this.lists);
}

// BLoC
class ShoppingListBloc extends Bloc<ShoppingListEvent, ShoppingListState> {
  ShoppingListBloc() : super(ShoppingListInitial()) {
    on<GetShoppingListsEvent>(_onGetShoppingLists);
  }
}
```

## Dependency Injection

We use GetIt for service locator pattern. Setup in `lib/injection.dart`:

```dart
final getIt = GetIt.instance;

void setupServiceLocator() {
  // Data sources
  getIt.registerSingleton<ShoppingListLocalDataSource>(
    ShoppingListLocalDataSourceImpl(),
  );
  
  // Repositories
  getIt.registerSingleton<ShoppingListRepository>(
    ShoppingListRepositoryImpl(getIt()),
  );
  
  // Use cases
  getIt.registerSingleton<GetShoppingListsUseCase>(
    GetShoppingListsUseCase(getIt()),
  );
  
  // BLoCs
  getIt.registerSingleton<ShoppingListBloc>(
    ShoppingListBloc(getIt()),
  );
}
```

## Contributing

1. Create a feature branch: `git checkout -b feature/your-feature`
2. Make changes following the project structure
3. Write tests for new features
4. Run `flutter test` and ensure all tests pass
5. Run `dart format .` to format code
6. Commit with clear messages: `git commit -m "feat: describe your change"`
7. Push and create a Pull Request

## Troubleshooting

### Build Issues
```bash
# Clean build artifacts
flutter clean

# Get fresh dependencies
flutter pub get

# Regenerate code
flutter pub run build_runner build --delete-conflicting-outputs
```

### Dependency Conflicts
```bash
# Update to latest compatible versions
flutter pub upgrade

# See dependency tree
flutter pub deps
```

## Environment Variables

Copy `.env.example` to `.env` for local configuration:
```bash
cp .env.example .env
```

Edit `.env` with your local settings.

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [BLoC Library Documentation](https://bloclibrary.dev/)
- [Clean Architecture Guide](https://resocoder.com/clean-architecture)
- [Hive Local Database](https://hivedb.dev/)
