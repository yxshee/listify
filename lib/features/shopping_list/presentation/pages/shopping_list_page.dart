import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/shopping_list_bloc.dart';
import '../bloc/shopping_list_event.dart';
import '../bloc/shopping_list_state.dart';
import '../widgets/shopping_item_tile.dart';
import '../widgets/add_item_dialog.dart';
import '../widgets/empty_list_view.dart';
import '../../../../core/theme/app_colors.dart';

/// Main shopping list page
/// 
/// Demonstrates:
/// - BLoC integration with BlocBuilder/BlocListener
/// - State-based UI rendering
/// - Snackbar notifications with undo
class ShoppingListPage extends StatelessWidget {
  const ShoppingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      floatingActionButton: _buildFab(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Shopping List'),
      actions: [
        // Clear completed button
        BlocBuilder<ShoppingListBloc, ShoppingListState>(
          builder: (context, state) {
            if (state is ShoppingListLoaded && state.hasCompletedItems) {
              return IconButton(
                icon: const Icon(Icons.playlist_remove_rounded),
                tooltip: 'Clear completed',
                onPressed: () => _showClearCompletedDialog(context),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        // Theme toggle would go here
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocConsumer<ShoppingListBloc, ShoppingListState>(
      listener: (context, state) {
        // Show snackbar when item is deleted
        if (state is ShoppingListLoaded && state.lastDeletedItem != null) {
          _showUndoSnackbar(context, state);
        }

        // Show error snackbar
        if (state is ShoppingListError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        return switch (state) {
          ShoppingListInitial() => const Center(
              child: CircularProgressIndicator(),
            ),
          ShoppingListLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
          ShoppingListError(:final message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error.withValues(alpha: 0.7),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context
                        .read<ShoppingListBloc>()
                        .add(const LoadShoppingItems()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ShoppingListLoaded(:final items) => items.isEmpty
              ? EmptyListView(
                  onAddPressed: () => _showAddItemDialog(context),
                )
              : _buildItemList(context, state),
        };
      },
    );
  }

  Widget _buildItemList(BuildContext context, ShoppingListLoaded state) {
    return CustomScrollView(
      slivers: [
        // Stats header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                _buildStatChip(
                  context,
                  icon: Icons.format_list_numbered_rounded,
                  label: '${state.totalCount} items',
                ),
                const SizedBox(width: 12),
                if (state.completedCount > 0)
                  _buildStatChip(
                    context,
                    icon: Icons.check_circle_outline,
                    label: '${state.completedCount} done',
                    isAccent: true,
                  ),
              ],
            ),
          ),
        ),

        // Active items section
        if (state.activeItems.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text(
                'To Buy',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = state.activeItems[index];
                return ShoppingItemTile(
                  item: item,
                  onToggle: () => context
                      .read<ShoppingListBloc>()
                      .add(ToggleShoppingItem(item.id)),
                  onDelete: () => context.read<ShoppingListBloc>().add(
                        DeleteShoppingItem(id: item.id, item: item),
                      ),
                );
              },
              childCount: state.activeItems.length,
            ),
          ),
        ],

        // Completed items section
        if (state.completedItems.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Row(
                children: [
                  Text(
                    'Completed',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => _showClearCompletedDialog(context),
                    icon: const Icon(Icons.delete_sweep, size: 18),
                    label: const Text('Clear'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.error,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = state.completedItems[index];
                return Opacity(
                  opacity: 0.7,
                  child: ShoppingItemTile(
                    item: item,
                    onToggle: () => context
                        .read<ShoppingListBloc>()
                        .add(ToggleShoppingItem(item.id)),
                    onDelete: () => context.read<ShoppingListBloc>().add(
                          DeleteShoppingItem(id: item.id, item: item),
                        ),
                  ),
                );
              },
              childCount: state.completedItems.length,
            ),
          ),
        ],

        // Bottom padding for FAB
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }

  Widget _buildStatChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    bool isAccent = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isAccent
            ? AppColors.accent.withValues(alpha: 0.1)
            : AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isAccent ? AppColors.accent : AppColors.primary,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isAccent ? AppColors.accent : AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _showAddItemDialog(context),
      icon: const Icon(Icons.add),
      label: const Text('Add Item'),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    AddItemDialog.show(
      context,
      onAdd: (title, category) {
        context.read<ShoppingListBloc>().add(
              AddShoppingItem(title: title, category: category),
            );
      },
    );
  }

  void _showClearCompletedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Completed Items?'),
        content: const Text(
          'This will permanently remove all completed items from your list.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context
                  .read<ShoppingListBloc>()
                  .add(const ClearCompletedItems());
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _showUndoSnackbar(BuildContext context, ShoppingListLoaded state) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${state.lastDeletedItem!.title} removed'),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: AppColors.accent,
          onPressed: () {
            context.read<ShoppingListBloc>().add(
                  UndoDeleteShoppingItem(
                    item: state.lastDeletedItem!,
                    originalIndex: state.lastDeletedIndex,
                  ),
                );
          },
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 80),
      ),
    );
  }
}
