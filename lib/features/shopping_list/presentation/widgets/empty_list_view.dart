import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Empty state view when there are no shopping items
/// 
/// Features:
/// - Animated illustration
/// - Clear call-to-action
/// - Modern styling
class EmptyListView extends StatelessWidget {
  final VoidCallback? onAddPressed;

  const EmptyListView({
    super.key,
    this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_basket_outlined,
                size: 80,
                color: AppColors.primary.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 32),

            // Title
            Text(
              'Your list is empty',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),

            // Subtitle
            Text(
              'Add items to your shopping list\nto get started',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),

            // Add button
            if (onAddPressed != null)
              ElevatedButton.icon(
                onPressed: onAddPressed,
                icon: const Icon(Icons.add),
                label: const Text('Add First Item'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
