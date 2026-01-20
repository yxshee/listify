import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/shopping_item.dart';
import '../../domain/repositories/shopping_repository.dart';
import 'shopping_list_event.dart';
import 'shopping_list_state.dart';

/// BLoC for managing shopping list state
/// 
/// This demonstrates the BLoC pattern for state management:
/// - Events trigger state changes
/// - States are immutable
/// - Side effects are handled via the repository
class ShoppingListBloc extends Bloc<ShoppingListEvent, ShoppingListState> {
  final ShoppingRepository _repository;

  ShoppingListBloc({required ShoppingRepository repository})
      : _repository = repository,
        super(const ShoppingListInitial()) {
    on<LoadShoppingItems>(_onLoadItems);
    on<AddShoppingItem>(_onAddItem);
    on<ToggleShoppingItem>(_onToggleItem);
    on<DeleteShoppingItem>(_onDeleteItem);
    on<UndoDeleteShoppingItem>(_onUndoDelete);
    on<ClearCompletedItems>(_onClearCompleted);
    on<FilterByCategory>(_onFilterByCategory);
  }

  /// Handles loading all shopping items
  Future<void> _onLoadItems(
    LoadShoppingItems event,
    Emitter<ShoppingListState> emit,
  ) async {
    emit(const ShoppingListLoading());

    final result = await _repository.getAllItems();

    result.fold(
      (failure) => emit(ShoppingListError(
        message: failure.message,
        code: failure.code,
      )),
      (items) => emit(ShoppingListLoaded(items: items)),
    );
  }

  /// Handles adding a new shopping item
  Future<void> _onAddItem(
    AddShoppingItem event,
    Emitter<ShoppingListState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ShoppingListLoaded) return;

    final result = await _repository.addItem(
      event.title,
      category: event.category,
    );

    result.fold(
      (failure) => emit(ShoppingListError(
        message: failure.message,
        code: failure.code,
      )),
      (item) => emit(currentState.copyWith(
        items: [item, ...currentState.items],
        clearLastDeleted: true,
      )),
    );
  }

  /// Handles toggling item completion status
  Future<void> _onToggleItem(
    ToggleShoppingItem event,
    Emitter<ShoppingListState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ShoppingListLoaded) return;

    final result = await _repository.toggleItem(event.id);

    result.fold(
      (failure) => emit(ShoppingListError(
        message: failure.message,
        code: failure.code,
      )),
      (updatedItem) {
        final updatedItems = currentState.items.map((item) {
          return item.id == updatedItem.id ? updatedItem : item;
        }).toList();
        emit(currentState.copyWith(items: updatedItems));
      },
    );
  }

  /// Handles deleting a shopping item
  Future<void> _onDeleteItem(
    DeleteShoppingItem event,
    Emitter<ShoppingListState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ShoppingListLoaded) return;

    // Find the index before deleting
    final index = currentState.items.indexWhere((item) => item.id == event.id);
    
    final result = await _repository.deleteItem(event.id);

    result.fold(
      (failure) => emit(ShoppingListError(
        message: failure.message,
        code: failure.code,
      )),
      (_) {
        final updatedItems =
            currentState.items.where((item) => item.id != event.id).toList();
        emit(currentState.copyWith(
          items: updatedItems,
          lastDeletedItem: event.item,
          lastDeletedIndex: index,
        ));
      },
    );
  }

  /// Handles undo of delete operation
  Future<void> _onUndoDelete(
    UndoDeleteShoppingItem event,
    Emitter<ShoppingListState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ShoppingListLoaded) return;

    // Re-add the item to the repository
    final result = await _repository.addItem(
      event.item.title,
      category: event.item.category,
    );

    result.fold(
      (failure) => emit(ShoppingListError(
        message: failure.message,
        code: failure.code,
      )),
      (restoredItem) {
        // Insert at original position if available
        final updatedItems = List<ShoppingItem>.from(currentState.items);
        final insertIndex = event.originalIndex != null &&
                event.originalIndex! <= updatedItems.length
            ? event.originalIndex!
            : 0;
        updatedItems.insert(insertIndex, restoredItem);
        emit(currentState.copyWith(
          items: updatedItems,
          clearLastDeleted: true,
        ));
      },
    );
  }

  /// Handles clearing all completed items
  Future<void> _onClearCompleted(
    ClearCompletedItems event,
    Emitter<ShoppingListState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ShoppingListLoaded) return;

    final result = await _repository.clearCompletedItems();

    result.fold(
      (failure) => emit(ShoppingListError(
        message: failure.message,
        code: failure.code,
      )),
      (_) {
        final updatedItems =
            currentState.items.where((item) => !item.isDone).toList();
        emit(currentState.copyWith(
          items: updatedItems,
          clearLastDeleted: true,
        ));
      },
    );
  }

  /// Handles filtering by category
  Future<void> _onFilterByCategory(
    FilterByCategory event,
    Emitter<ShoppingListState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ShoppingListLoaded) return;

    if (event.category == null) {
      // Load all items if no category filter
      add(const LoadShoppingItems());
    } else {
      final result = await _repository.getItemsByCategory(event.category!);

      result.fold(
        (failure) => emit(ShoppingListError(
          message: failure.message,
          code: failure.code,
        )),
        (items) => emit(ShoppingListLoaded(
          items: items,
          selectedCategory: event.category,
        )),
      );
    }
  }
}
