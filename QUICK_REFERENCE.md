# Quick Reference Guide

## Common Commands

```bash
# Setup
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

# Run
flutter run                    # Debug mode
flutter run --release          # Release mode
flutter run -d web            # Web platform

# Testing
flutter test                  # Run all tests
flutter test --coverage       # With coverage report
flutter pub run build_runner watch  # Continuous generation

# Code Quality
dart analyze                  # Analyze code
dart format .                 # Format code
flutter analyze --no-pub      # Run linter
```

## File Locations

| Task | Location |
|------|----------|
| Theme & Colors | `lib/config/theme/` |
| Routes | `lib/config/routes/` |
| Shared Widgets | `lib/shared/widgets/` |
| Utilities | `lib/shared/utils/` |
| Constants | `lib/shared/constants/` |
| Extensions | `lib/shared/extensions/` |
| Feature Logic | `lib/features/shopping_list/` |
| Tests | `test/` |
| Docs | `docs/`, `*.md` |

## Architecture Layers

```
┌─────────────────────────────────────┐
│     Presentation Layer (UI)         │
│  Pages, Widgets, BLoC, State        │
└──────────────┬──────────────────────┘
               │ depends on
┌──────────────▼──────────────────────┐
│     Domain Layer (Business Logic)   │
│  Entities, Use Cases, Interfaces    │
└──────────────┬──────────────────────┘
               │ depends on
┌──────────────▼──────────────────────┐
│     Data Layer (Repositories)       │
│  Models, Data Sources, Repositories│
└─────────────────────────────────────┘
```

## Adding a New Feature

1. Create folder in `lib/features/your_feature/`
2. Structure:
   ```
   your_feature/
   ├── data/
   │   ├── datasources/
   │   ├── models/
   │   └── repositories/
   ├── domain/
   │   ├── entities/
   │   ├── repositories/
   │   └── usecases/
   ├── presentation/
   │   ├── bloc/
   │   ├── pages/
   │   └── widgets/
   └── core/
   ```

3. Implement layers bottom-up (Data → Domain → Presentation)
4. Write tests for each layer
5. Register in `lib/injection.dart`

## BLoC Structure Example

```dart
// Event
abstract class YourEvent extends Equatable {}
class GetDataEvent extends YourEvent {
  @override
  List<Object?> get props => [];
}

// State
abstract class YourState extends Equatable {}
class YourInitial extends YourState {
  @override
  List<Object?> get props => [];
}
class YourLoading extends YourState {
  @override
  List<Object?> get props => [];
}
class YourLoaded extends YourState {
  final List<Data> data;
  YourLoaded(this.data);
  @override
  List<Object?> get props => [data];
}

// BLoC
class YourBloc extends Bloc<YourEvent, YourState> {
  final GetDataUseCase getDataUseCase;
  
  YourBloc(this.getDataUseCase) : super(YourInitial()) {
    on<GetDataEvent>(_onGetData);
  }
  
  Future<void> _onGetData(GetDataEvent event, Emitter<YourState> emit) async {
    emit(YourLoading());
    final result = await getDataUseCase();
    result.fold(
      (failure) => emit(YourError(failure.message)),
      (data) => emit(YourLoaded(data)),
    );
  }
}
```

## Environment Variables

```bash
# Copy example
cp .env.example .env

# Edit .env with local values
# .env is git ignored, won't be committed
```

## Naming Conventions

- **Files**: `snake_case.dart`
- **Classes**: `PascalCase` (e.g., `ShoppingListBloc`)
- **Functions/Variables**: `camelCase` (e.g., `getShoppingList()`)
- **Constants**: `camelCase` (e.g., `maxItems = 100`)
- **Folders**: `snake_case` (e.g., `shopping_list/`)

## Useful Packages

| Package | Purpose |
|---------|---------|
| `flutter_bloc` | State management |
| `hive_flutter` | Local persistence |
| `get_it` | Dependency injection |
| `dartz` | Functional programming |
| `equatable` | Value comparison |
| `uuid` | Unique IDs |
| `intl` | Internationalization |

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Build failed | `flutter clean && flutter pub get` |
| Generated code missing | `flutter pub run build_runner build --delete-conflicting-outputs` |
| Dependency conflict | `flutter pub upgrade` or `flutter pub get` |
| Import errors | Check `pubspec.yaml` and run `flutter pub get` |

## Documentation

- [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) - Full structure guide
- [DEVELOPMENT.md](DEVELOPMENT.md) - Development workflow
- [CONTRIBUTING.md](CONTRIBUTING.md) - How to contribute
- [STRUCTURE_CHANGELOG.md](STRUCTURE_CHANGELOG.md) - What changed

---

**📖 Need more help?** Check the full documentation files above!
