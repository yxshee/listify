import 'package:dartz/dartz.dart';
import '../entities/shopping_item.dart';
import '../../core/failures.dart';

/// Repository interface for shopping list operations
/// 
/// This defines the contract for data operations without
/// specifying implementation details (Clean Architecture principle).
abstract class ShoppingRepository {
  /// Retrieves all shopping items
  Future<Either<Failure, List<ShoppingItem>>> getAllItems();

  /// Adds a new shopping item
  Future<Either<Failure, ShoppingItem>> addItem(String title, {String? category});

  /// Updates an existing shopping item
  Future<Either<Failure, ShoppingItem>> updateItem(ShoppingItem item);

  /// Toggles the completion status of an item
  Future<Either<Failure, ShoppingItem>> toggleItem(String id);

  /// Deletes a shopping item
  Future<Either<Failure, void>> deleteItem(String id);

  /// Deletes all completed items
  Future<Either<Failure, void>> clearCompletedItems();

  /// Gets items filtered by category
  Future<Either<Failure, List<ShoppingItem>>> getItemsByCategory(String category);

  /// Watches for changes to the shopping list (for reactive updates)
  Stream<List<ShoppingItem>> watchAllItems();
}
