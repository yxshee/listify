import 'package:equatable/equatable.dart';
import '../../domain/entities/shopping_item.dart';

/// Base class for all shopping list events
sealed class ShoppingListEvent extends Equatable {
  const ShoppingListEvent();

  @override
  List<Object?> get props => [];
}

/// Load all shopping items
class LoadShoppingItems extends ShoppingListEvent {
  const LoadShoppingItems();
}

/// Add a new shopping item
class AddShoppingItem extends ShoppingListEvent {
  final String title;
  final String? category;

  const AddShoppingItem({
    required this.title,
    this.category,
  });

  @override
  List<Object?> get props => [title, category];
}

/// Toggle item completion status
class ToggleShoppingItem extends ShoppingListEvent {
  final String id;

  const ToggleShoppingItem(this.id);

  @override
  List<Object?> get props => [id];
}

/// Delete a shopping item
class DeleteShoppingItem extends ShoppingListEvent {
  final String id;
  final ShoppingItem item; // Keep reference for undo

  const DeleteShoppingItem({
    required this.id,
    required this.item,
  });

  @override
  List<Object?> get props => [id, item];
}

/// Undo the last delete operation
class UndoDeleteShoppingItem extends ShoppingListEvent {
  final ShoppingItem item;
  final int? originalIndex;

  const UndoDeleteShoppingItem({
    required this.item,
    this.originalIndex,
  });

  @override
  List<Object?> get props => [item, originalIndex];
}

/// Clear all completed items
class ClearCompletedItems extends ShoppingListEvent {
  const ClearCompletedItems();
}

/// Filter items by category
class FilterByCategory extends ShoppingListEvent {
  final String? category;

  const FilterByCategory(this.category);

  @override
  List<Object?> get props => [category];
}
