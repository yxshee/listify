import 'package:get_it/get_it.dart';
import 'features/shopping_list/data/datasources/local_datasource.dart';
import 'features/shopping_list/data/repositories/shopping_repository_impl.dart';
import 'features/shopping_list/domain/repositories/shopping_repository.dart';
import 'features/shopping_list/presentation/bloc/shopping_list_bloc.dart';

/// Service locator for dependency injection
/// 
/// Uses GetIt for simple, type-safe dependency injection.
/// This pattern allows for easy testing by swapping implementations.
final GetIt sl = GetIt.instance;

/// Initialize all dependencies
/// 
/// Call this in main() before runApp()
Future<void> initializeDependencies() async {
  // Data sources (singleton - one instance for entire app)
  final localDataSource = ShoppingLocalDataSource();
  await localDataSource.init();
  sl.registerLazySingleton<ShoppingLocalDataSource>(() => localDataSource);

  // Repositories (singleton)
  sl.registerLazySingleton<ShoppingRepository>(
    () => ShoppingRepositoryImpl(localDataSource: sl()),
  );

  // BLoCs (factory - new instance each time)
  sl.registerFactory<ShoppingListBloc>(
    () => ShoppingListBloc(repository: sl()),
  );
}
