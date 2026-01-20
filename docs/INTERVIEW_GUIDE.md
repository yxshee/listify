# Listify - Flutter Interview Guide

This document outlines key concepts and talking points for discussing this project in Flutter development interviews.

---

## 🏗️ Clean Architecture

**Q: Why did you choose Clean Architecture?**

> Clean Architecture provides clear separation of concerns:
> - **Presentation Layer**: UI and state management (BLoC)
> - **Domain Layer**: Business entities and repository interfaces
> - **Data Layer**: Implementations, data sources, models
>
> Benefits: Testability, maintainability, and the ability to swap implementations (e.g., change from Hive to SQLite) without touching business logic.

**Q: How do the layers communicate?**

> - UI → BLoC (via events)
> - BLoC → Repository Interface (dependency inversion)
> - Repository Implementation → DataSource → Database
>
> The dependency rule: outer layers depend on inner layers, never the reverse.

---

## 📊 State Management (BLoC)

**Q: Why BLoC over Provider or Riverpod?**

> - **Predictability**: Unidirectional data flow (Event → BLoC → State)
> - **Testability**: `bloc_test` makes testing straightforward
> - **Scalability**: Clean separation of concerns, great for large apps
> - **Industry Standard**: Widely used in production Flutter apps

**Q: Explain your state design.**

> I use sealed classes for type-safe state handling:
> ```dart
> sealed class ShoppingListState {}
> class ShoppingListInitial extends ShoppingListState {}
> class ShoppingListLoading extends ShoppingListState {}
> class ShoppingListLoaded extends ShoppingListState {}
> class ShoppingListError extends ShoppingListState {}
> ```
>
> This enables exhaustive switch statements and compile-time safety.

---

## 💾 Data Persistence (Hive)

**Q: Why Hive over SQLite?**

> - **Performance**: Hive is faster for simple key-value/object storage
> - **No Native Dependencies**: Pure Dart implementation
> - **Type-Safe**: Code generation creates type adapters
> - **Simple API**: Less boilerplate than SQLite
>
> For relational data or complex queries, I'd consider SQLite with `drift`.

---

## ⚠️ Error Handling

**Q: How do you handle errors?**

> I use the `Either` type from dartz for functional error handling:
> ```dart
> Future<Either<Failure, List<ShoppingItem>>> getAllItems()
> ```
>
> - `Left` = Failure (with typed error)
> - `Right` = Success (with data)
>
> This forces explicit error handling and prevents silent failures.

---

## 💉 Dependency Injection

**Q: Why GetIt?**

> - **Simple**: Easy to understand and configure
> - **No Code Generation**: Unlike injectable, no build step required
> - **Flexible**: Supports singletons, factories, lazy loading
> - **Testable**: Easy to swap implementations for testing

---

## 🧪 Testing Strategy

**Q: What's your testing approach?**

> **Unit Tests**: Test BLoC logic in isolation using `mocktail` for mocking
> 
> **Widget Tests**: Test UI components render correctly and respond to interactions
>
> **Integration Tests**: Test complete user flows
>
> I aim for high coverage on business logic (BLoC) where bugs are most impactful.

---

## 🔄 CI/CD

**Q: Describe your CI/CD pipeline.**

> GitHub Actions workflow that:
> 1. **Analyzes** code with `flutter analyze`
> 2. **Runs tests** with coverage reporting
> 3. **Builds** for Android, iOS, and Web
> 4. **Uploads** artifacts for deployment
>
> This ensures code quality and catches issues before merge.

---

## 📱 UI/UX

**Q: How did you approach theming?**

> - **Material Design 3**: Using ColorScheme for consistency
> - **Dark Mode**: Automatic system detection via `ThemeMode.system`
> - **Centralized**: All colors/styles in `core/theme/`
> - **Responsive**: Adaptable to different screen sizes

---

## 🎯 Key Concepts Demonstrated

| Concept | Implementation |
|---------|----------------|
| Clean Architecture | Domain, Data, Presentation layers |
| BLoC Pattern | Events, States, Bloc class |
| Repository Pattern | Interface + Implementation |
| Dependency Injection | GetIt service locator |
| Functional Error Handling | Either type (dartz) |
| Immutable State | Equatable, copyWith |
| Testing | bloc_test, mocktail, flutter_test |
| CI/CD | GitHub Actions |

---

## 💡 Improvements I'd Make

1. **Add Search**: Filter items in real-time
2. **Categories**: Group items by type
3. **Cloud Sync**: Firebase/Supabase integration
4. **Sharing**: Share lists with others
5. **Offline-First**: Sync when online

---

## 🗣️ Questions to Ask Interviewer

1. What state management solution does your team use?
2. How do you approach testing in Flutter projects?
3. What's your deployment/CI-CD pipeline like?
4. How do you handle app architecture as the codebase grows?
