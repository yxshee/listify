# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-01-20

### Added
- 🏗️ **Clean Architecture** - Domain, Data, and Presentation layers
- 📊 **BLoC State Management** - Reactive, predictable state handling
- 💾 **Hive Persistence** - Local storage for shopping items
- 💉 **Dependency Injection** - GetIt service locator
- 🎨 **Material Design 3** - Modern theming with dark mode support
- ✅ **Add Items** - Quick item addition with dialog
- ✔️ **Complete Items** - Mark items as purchased
- 👆 **Swipe to Delete** - Gesture-based item removal
- ↩️ **Undo Support** - Restore deleted items
- 🧪 **Testing** - Unit and widget tests (17 tests)
- 🔄 **CI/CD** - GitHub Actions pipeline
- 📱 **Cross-Platform** - Android, iOS, and Web support

### Changed
- Migrated from `setState` to BLoC pattern
- Restructured project to Clean Architecture
- Updated dependencies to latest versions

### Removed
- Legacy `code/` folder with old implementation
- Deprecated `FlatButton` usage
