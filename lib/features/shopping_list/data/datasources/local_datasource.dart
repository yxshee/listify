import 'package:hive_flutter/hive_flutter.dart';
import '../models/shopping_item_model.dart';

/// Local data source for shopping items using Hive
/// 
/// Handles all direct interactions with the Hive database.
class ShoppingLocalDataSource {
  static const String _boxName = 'shopping_items';

  late Box<ShoppingItemModel> _box;

  /// Initializes Hive and opens the shopping items box
  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ShoppingItemModelAdapter());
    _box = await Hive.openBox<ShoppingItemModel>(_boxName);
  }

  /// Gets all items from the box
  List<ShoppingItemModel> getAllItems() {
    return _box.values.toList();
  }

  /// Gets a single item by ID
  ShoppingItemModel? getItemById(String id) {
    try {
      return _box.values.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Adds or updates an item
  Future<void> saveItem(ShoppingItemModel item) async {
    // Find existing item by ID or add new
    final existingKey = _findKeyById(item.id);
    if (existingKey != null) {
      await _box.put(existingKey, item);
    } else {
      await _box.add(item);
    }
  }

  /// Deletes an item by ID
  Future<void> deleteItem(String id) async {
    final key = _findKeyById(id);
    if (key != null) {
      await _box.delete(key);
    }
  }

  /// Deletes all completed items
  Future<void> clearCompletedItems() async {
    final keysToDelete = <dynamic>[];
    for (final key in _box.keys) {
      final item = _box.get(key);
      if (item?.isDone == true) {
        keysToDelete.add(key);
      }
    }
    await _box.deleteAll(keysToDelete);
  }

  /// Gets items by category
  List<ShoppingItemModel> getItemsByCategory(String category) {
    return _box.values.where((item) => item.category == category).toList();
  }

  /// Watches for changes to the box
  Stream<List<ShoppingItemModel>> watchAllItems() {
    return _box.watch().map((_) => getAllItems());
  }

  /// Helper to find box key by item ID
  dynamic _findKeyById(String id) {
    for (final key in _box.keys) {
      if (_box.get(key)?.id == id) {
        return key;
      }
    }
    return null;
  }
}
