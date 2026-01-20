import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:listify/features/shopping_list/core/failures.dart';
import 'package:listify/features/shopping_list/domain/entities/shopping_item.dart';
import 'package:listify/features/shopping_list/domain/repositories/shopping_repository.dart';
import 'package:listify/features/shopping_list/presentation/bloc/shopping_list_bloc.dart';
import 'package:listify/features/shopping_list/presentation/bloc/shopping_list_event.dart';
import 'package:listify/features/shopping_list/presentation/bloc/shopping_list_state.dart';

/// Mock repository for testing
class MockShoppingRepository extends Mock implements ShoppingRepository {}

void main() {
  late ShoppingListBloc bloc;
  late MockShoppingRepository mockRepository;

  setUp(() {
    mockRepository = MockShoppingRepository();
    bloc = ShoppingListBloc(repository: mockRepository);
  });

  tearDown(() {
    bloc.close();
  });

  final testItem = ShoppingItem(
    id: 'test-id-1',
    title: 'Test Item',
    isDone: false,
    createdAt: DateTime(2024, 1, 1),
  );

  final testItems = [
    testItem,
    ShoppingItem(
      id: 'test-id-2',
      title: 'Second Item',
      isDone: true,
      createdAt: DateTime(2024, 1, 2),
    ),
  ];

  group('ShoppingListBloc', () {
    test('initial state is ShoppingListInitial', () {
      expect(bloc.state, equals(const ShoppingListInitial()));
    });

    group('LoadShoppingItems', () {
      blocTest<ShoppingListBloc, ShoppingListState>(
        'emits [Loading, Loaded] when items are loaded successfully',
        build: () {
          when(() => mockRepository.getAllItems())
              .thenAnswer((_) async => Right(testItems));
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadShoppingItems()),
        expect: () => [
          const ShoppingListLoading(),
          ShoppingListLoaded(items: testItems),
        ],
        verify: (_) {
          verify(() => mockRepository.getAllItems()).called(1);
        },
      );

      blocTest<ShoppingListBloc, ShoppingListState>(
        'emits [Loading, Error] when loading fails',
        build: () {
          when(() => mockRepository.getAllItems())
              .thenAnswer((_) async => const Left(StorageFailure()));
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadShoppingItems()),
        expect: () => [
          const ShoppingListLoading(),
          const ShoppingListError(
            message: 'An error occurred while accessing local storage',
            code: 'STORAGE_ERROR',
          ),
        ],
      );
    });

    group('AddShoppingItem', () {
      blocTest<ShoppingListBloc, ShoppingListState>(
        'emits updated list when item is added successfully',
        build: () {
          when(() => mockRepository.addItem(any(), category: any(named: 'category')))
              .thenAnswer((_) async => Right(testItem));
          return bloc;
        },
        seed: () => const ShoppingListLoaded(items: []),
        act: (bloc) => bloc.add(const AddShoppingItem(title: 'Test Item')),
        expect: () => [
          ShoppingListLoaded(items: [testItem]),
        ],
        verify: (_) {
          verify(() => mockRepository.addItem('Test Item', category: null))
              .called(1);
        },
      );
    });

    group('ToggleShoppingItem', () {
      final toggledItem = testItem.copyWith(isDone: true);

      blocTest<ShoppingListBloc, ShoppingListState>(
        'emits updated list when item is toggled successfully',
        build: () {
          when(() => mockRepository.toggleItem(any()))
              .thenAnswer((_) async => Right(toggledItem));
          return bloc;
        },
        seed: () => ShoppingListLoaded(items: [testItem]),
        act: (bloc) => bloc.add(ToggleShoppingItem(testItem.id)),
        expect: () => [
          ShoppingListLoaded(items: [toggledItem]),
        ],
      );
    });

    group('DeleteShoppingItem', () {
      blocTest<ShoppingListBloc, ShoppingListState>(
        'emits updated list with item removed and stores deleted item for undo',
        build: () {
          when(() => mockRepository.deleteItem(any()))
              .thenAnswer((_) async => const Right(null));
          return bloc;
        },
        seed: () => ShoppingListLoaded(items: [testItem]),
        act: (bloc) => bloc.add(DeleteShoppingItem(id: testItem.id, item: testItem)),
        expect: () => [
          ShoppingListLoaded(
            items: const [],
            lastDeletedItem: testItem,
            lastDeletedIndex: 0,
          ),
        ],
      );
    });

    group('ClearCompletedItems', () {
      blocTest<ShoppingListBloc, ShoppingListState>(
        'removes completed items from the list',
        build: () {
          when(() => mockRepository.clearCompletedItems())
              .thenAnswer((_) async => const Right(null));
          return bloc;
        },
        seed: () => ShoppingListLoaded(items: testItems),
        act: (bloc) => bloc.add(const ClearCompletedItems()),
        expect: () => [
          ShoppingListLoaded(items: [testItems[0]]),
        ],
      );
    });
  });

  group('ShoppingListState', () {
    test('ShoppingListLoaded computes activeItems correctly', () {
      final state = ShoppingListLoaded(items: testItems);
      expect(state.activeItems.length, equals(1));
      expect(state.activeItems.first.isDone, equals(false));
    });

    test('ShoppingListLoaded computes completedItems correctly', () {
      final state = ShoppingListLoaded(items: testItems);
      expect(state.completedItems.length, equals(1));
      expect(state.completedItems.first.isDone, equals(true));
    });

    test('ShoppingListLoaded.copyWith works correctly', () {
      final state = ShoppingListLoaded(items: testItems);
      final newState = state.copyWith(items: [testItem]);
      expect(newState.items.length, equals(1));
    });
  });

  group('ShoppingItem', () {
    test('copyWith creates correct copy', () {
      final copy = testItem.copyWith(isDone: true);
      expect(copy.id, equals(testItem.id));
      expect(copy.title, equals(testItem.title));
      expect(copy.isDone, equals(true));
    });

    test('props are correct for equality', () {
      final item1 = ShoppingItem(
        id: '1',
        title: 'Test',
        isDone: false,
        createdAt: DateTime(2024, 1, 1),
      );
      final item2 = ShoppingItem(
        id: '1',
        title: 'Test',
        isDone: false,
        createdAt: DateTime(2024, 1, 1),
      );
      expect(item1, equals(item2));
    });
  });
}
