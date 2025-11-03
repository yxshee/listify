import 'package:equatable/equatable.dart';
import '../../domain/entities/shopping_item.dart';

/// Base class for all shopping list states
sealed class ShoppingListState extends Equatable {
  const ShoppingListState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any data is loaded
class ShoppingListInitial extends ShoppingListState {
  const ShoppingListInitial();
}

/// Loading state while fetching data
class ShoppingListLoading extends ShoppingListState {
  const ShoppingListLoading();
}

/// Loaded state with shopping items
class ShoppingListLoaded extends ShoppingListState {
  final List<ShoppingItem> items;
  final String? selectedCategory;
  final ShoppingItem? lastDeletedItem;
  final int? lastDeletedIndex;

  const ShoppingListLoaded({
    required this.items,
    this.selectedCategory,
    this.lastDeletedItem,
    this.lastDeletedIndex,
  });

  /// Active (uncompleted) items
  List<ShoppingItem> get activeItems =>
      items.where((item) => !item.isDone).toList();

  /// Completed items
  List<ShoppingItem> get completedItems =>
      items.where((item) => item.isDone).toList();

  /// Total item count
  int get totalCount => items.length;

  /// Completed item count
  int get completedCount => completedItems.length;

  /// Check if there are any completed items
  bool get hasCompletedItems => completedItems.isNotEmpty;

  /// Create a copy with updated fields
  ShoppingListLoaded copyWith({
    List<ShoppingItem>? items,
    String? selectedCategory,
    ShoppingItem? lastDeletedItem,
    int? lastDeletedIndex,
    bool clearLastDeleted = false,
  }) {
    return ShoppingListLoaded(
      items: items ?? this.items,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      lastDeletedItem: clearLastDeleted ? null : (lastDeletedItem ?? this.lastDeletedItem),
      lastDeletedIndex: clearLastDeleted ? null : (lastDeletedIndex ?? this.lastDeletedIndex),
    );
  }

  @override
  List<Object?> get props => [items, selectedCategory, lastDeletedItem, lastDeletedIndex];
}

/// Error state with failure message
class ShoppingListError extends ShoppingListState {
  final String message;
  final String? code;

  const ShoppingListError({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}
