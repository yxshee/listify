import 'package:equatable/equatable.dart';

/// Domain entity representing a shopping item
/// 
/// This is the core business object used throughout the application.
/// It is immutable and uses [Equatable] for value comparison.
class ShoppingItem extends Equatable {
  /// Unique identifier for the item
  final String id;

  /// The name/title of the shopping item
  final String title;

  /// Whether this item has been purchased/completed
  final bool isDone;

  /// When this item was created
  final DateTime createdAt;

  /// Optional category for grouping items
  final String? category;

  const ShoppingItem({
    required this.id,
    required this.title,
    this.isDone = false,
    required this.createdAt,
    this.category,
  });

  /// Creates a copy of this item with the given fields replaced
  ShoppingItem copyWith({
    String? id,
    String? title,
    bool? isDone,
    DateTime? createdAt,
    String? category,
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
    );
  }

  @override
  List<Object?> get props => [id, title, isDone, createdAt, category];

  @override
  String toString() => 'ShoppingItem(id: $id, title: $title, isDone: $isDone)';
}
