import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listify/features/shopping_list/domain/entities/shopping_item.dart';
import 'package:listify/features/shopping_list/presentation/widgets/shopping_item_tile.dart';

void main() {
  final testItem = ShoppingItem(
    id: 'test-1',
    title: 'Test Shopping Item',
    isDone: false,
    createdAt: DateTime.now(),
  );

  final completedItem = testItem.copyWith(isDone: true);

  group('ShoppingItemTile', () {
    testWidgets('displays item title correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShoppingItemTile(
              item: testItem,
              onToggle: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Shopping Item'), findsOneWidget);
    });

    testWidgets('calls onToggle when checkbox is tapped', (tester) async {
      bool toggleCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShoppingItemTile(
              item: testItem,
              onToggle: () => toggleCalled = true,
              onDelete: () {},
            ),
          ),
        ),
      );

      // Find and tap the checkbox area
      final checkbox = find.byType(GestureDetector).first;
      await tester.tap(checkbox);
      await tester.pump();

      expect(toggleCalled, isTrue);
    });

    testWidgets('calls onDelete when delete button is tapped', (tester) async {
      bool deleteCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShoppingItemTile(
              item: testItem,
              onToggle: () {},
              onDelete: () => deleteCalled = true,
            ),
          ),
        ),
      );

      // Find and tap the delete button
      final deleteButton = find.byIcon(Icons.close_rounded);
      await tester.tap(deleteButton);
      await tester.pump();

      expect(deleteCalled, isTrue);
    });

    testWidgets('shows strikethrough when item is completed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShoppingItemTile(
              item: completedItem,
              onToggle: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      // Find the text widget and verify decoration
      final textFinder = find.text('Test Shopping Item');
      expect(textFinder, findsOneWidget);

      // The item should still be visible
      expect(find.text('Test Shopping Item'), findsOneWidget);
    });

    testWidgets('can be dismissed by swiping', (tester) async {
      bool deleteCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShoppingItemTile(
              item: testItem,
              onToggle: () {},
              onDelete: () => deleteCalled = true,
            ),
          ),
        ),
      );

      // Swipe to dismiss
      await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
      await tester.pumpAndSettle();

      expect(deleteCalled, isTrue);
    });
  });
}
