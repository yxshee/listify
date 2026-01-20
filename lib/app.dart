import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'features/shopping_list/presentation/bloc/shopping_list_bloc.dart';
import 'features/shopping_list/presentation/bloc/shopping_list_event.dart';
import 'features/shopping_list/presentation/pages/shopping_list_page.dart';
import 'injection.dart';

/// Root application widget
/// 
/// Provides:
/// - MaterialApp configuration
/// - Light/Dark theme support
/// - BLoC providers
class ListifyApp extends StatelessWidget {
  const ListifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Listify',
      debugShowCheckedModeBanner: false,
      
      // Theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Follow system preference
      
      // BLoC providers
      home: BlocProvider(
        create: (context) => sl<ShoppingListBloc>()
          ..add(const LoadShoppingItems()),
        child: const ShoppingListPage(),
      ),
    );
  }
}
