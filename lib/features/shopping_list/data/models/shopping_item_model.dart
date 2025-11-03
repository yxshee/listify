import 'package:hive/hive.dart';
import '../../domain/entities/shopping_item.dart';

part 'shopping_item_model.g.dart';

/// Data model for Hive persistence
/// 
/// This extends [HiveObject] for Hive database operations and includes
/// conversion methods to/from domain entities.
@HiveType(typeId: 0)
class ShoppingItemModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late bool isDone;

  @HiveField(3)
  late DateTime createdAt;

  @HiveField(4)
  String? category;

  ShoppingItemModel();

  /// Creates a model from a domain entity
  factory ShoppingItemModel.fromEntity(ShoppingItem item) {
    return ShoppingItemModel()
      ..id = item.id
      ..title = item.title
      ..isDone = item.isDone
      ..createdAt = item.createdAt
      ..category = item.category;
  }

  /// Converts this model to a domain entity
  ShoppingItem toEntity() {
    return ShoppingItem(
      id: id,
      title: title,
      isDone: isDone,
      createdAt: createdAt,
      category: category,
    );
  }
}
