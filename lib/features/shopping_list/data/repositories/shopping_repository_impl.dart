import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/shopping_item.dart';
import '../../domain/repositories/shopping_repository.dart';
import '../../core/failures.dart';
import '../datasources/local_datasource.dart';
import '../models/shopping_item_model.dart';

/// Implementation of [ShoppingRepository] using local storage
/// 
/// This demonstrates the Repository pattern - isolating data access
/// logic from the business layer.
class ShoppingRepositoryImpl implements ShoppingRepository {
  final ShoppingLocalDataSource _localDataSource;
  final Uuid _uuid;

  ShoppingRepositoryImpl({
    required ShoppingLocalDataSource localDataSource,
    Uuid? uuid,
  })  : _localDataSource = localDataSource,
        _uuid = uuid ?? const Uuid();

  @override
  Future<Either<Failure, List<ShoppingItem>>> getAllItems() async {
    try {
      final models = _localDataSource.getAllItems();
      final items = models.map((m) => m.toEntity()).toList();
      // Sort by creation date, newest first
      items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return Right(items);
    } catch (e) {
      return const Left(StorageFailure());
    }
  }

  @override
  Future<Either<Failure, ShoppingItem>> addItem(
    String title, {
    String? category,
  }) async {
    try {
      if (title.trim().isEmpty) {
        return const Left(
          ValidationFailure(message: 'Item title cannot be empty'),
        );
      }

      final item = ShoppingItem(
        id: _uuid.v4(),
        title: title.trim(),
        isDone: false,
        createdAt: DateTime.now(),
        category: category,
      );

      final model = ShoppingItemModel.fromEntity(item);
      await _localDataSource.saveItem(model);
      return Right(item);
    } catch (e) {
      return const Left(StorageFailure());
    }
  }

  @override
  Future<Either<Failure, ShoppingItem>> updateItem(ShoppingItem item) async {
    try {
      final existingModel = _localDataSource.getItemById(item.id);
      if (existingModel == null) {
        return const Left(NotFoundFailure());
      }

      final model = ShoppingItemModel.fromEntity(item);
      await _localDataSource.saveItem(model);
      return Right(item);
    } catch (e) {
      return const Left(StorageFailure());
    }
  }

  @override
  Future<Either<Failure, ShoppingItem>> toggleItem(String id) async {
    try {
      final existingModel = _localDataSource.getItemById(id);
      if (existingModel == null) {
        return const Left(NotFoundFailure());
      }

      final updatedEntity = existingModel.toEntity().copyWith(
            isDone: !existingModel.isDone,
          );
      final updatedModel = ShoppingItemModel.fromEntity(updatedEntity);
      await _localDataSource.saveItem(updatedModel);
      return Right(updatedEntity);
    } catch (e) {
      return const Left(StorageFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteItem(String id) async {
    try {
      final existingModel = _localDataSource.getItemById(id);
      if (existingModel == null) {
        return const Left(NotFoundFailure());
      }

      await _localDataSource.deleteItem(id);
      return const Right(null);
    } catch (e) {
      return const Left(StorageFailure());
    }
  }

  @override
  Future<Either<Failure, void>> clearCompletedItems() async {
    try {
      await _localDataSource.clearCompletedItems();
      return const Right(null);
    } catch (e) {
      return const Left(StorageFailure());
    }
  }

  @override
  Future<Either<Failure, List<ShoppingItem>>> getItemsByCategory(
    String category,
  ) async {
    try {
      final models = _localDataSource.getItemsByCategory(category);
      final items = models.map((m) => m.toEntity()).toList();
      items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return Right(items);
    } catch (e) {
      return const Left(StorageFailure());
    }
  }

  @override
  Stream<List<ShoppingItem>> watchAllItems() {
    return _localDataSource.watchAllItems().map(
          (models) => models.map((m) => m.toEntity()).toList(),
        );
  }
}
