# Contributing to Listify

Thank you for your interest in contributing to Listify! 🎉

## Getting Started

1. **Fork** the repository
2. **Clone** your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/listify.git
   ```
3. **Install** dependencies:
   ```bash
   flutter pub get
   dart run build_runner build --delete-conflicting-outputs
   ```

## Development Setup

### Prerequisites
- Flutter SDK 3.16+
- Dart 3.0+
- An IDE (VS Code or Android Studio recommended)

### Running the App
```bash
flutter run
```

### Running Tests
```bash
flutter test
```

## Code Style

We follow the official [Dart style guide](https://dart.dev/guides/language/effective-dart/style) with these additions:

- Use `flutter analyze` before committing
- All public APIs should have documentation
- Follow Clean Architecture patterns

## Pull Request Process

1. Create a feature branch: `git checkout -b feature/your-feature`
2. Make your changes
3. Run tests: `flutter test`
4. Run analysis: `flutter analyze`
5. Commit with meaningful messages
6. Push and create a Pull Request

## Architecture Guidelines

Follow the existing Clean Architecture structure:

```
lib/features/[feature_name]/
├── data/           # Data layer
├── domain/         # Domain layer  
└── presentation/   # Presentation layer
```

## Questions?

Open an issue for any questions or discussions.
