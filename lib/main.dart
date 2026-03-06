import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:news_app/core/network/api_service.dart';
import 'package:news_app/core/storage/local_storage.dart';
import 'package:news_app/features/articles/data/datasources/articles_remote_datasource.dart';
import 'package:news_app/features/articles/data/datasources/favorites_local_datasource.dart';
import 'package:news_app/features/articles/data/repositories/articles_repository.dart';
import 'package:news_app/features/articles/presentation/cubit/articles_cubit.dart';
import 'package:news_app/features/articles/presentation/cubit/favorites_cubit.dart';
import 'package:news_app/features/articles/presentation/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();
  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = ArticlesRepository(
      ArticlesRemoteDatasource(ApiService()),
      FavoritesLocalDatasource(),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ArticlesCubit(repository)),
        BlocProvider(
          create: (_) => FavoritesCubit(repository)..loadFavorites(),
        ),
      ],
      child: MaterialApp(
        title: 'News & Insight',
        debugShowCheckedModeBanner: false,
        theme: _lightTheme(),
        darkTheme: _darkTheme(),
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }

  ThemeData _lightTheme() {
    const primary = Color(0xFF1A73E8);

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
        surface: const Color(0xFFF6F8FC),
      ),
      scaffoldBackgroundColor: const Color(0xFFF6F8FC),
      cardTheme: CardThemeData(
        elevation: 3,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        scrolledUnderElevation: 1,
        backgroundColor: Color(0xFFF6F8FC),
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A1A2E),
        ),
        iconTheme: IconThemeData(color: Color(0xFF1A73E8)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  ThemeData _darkTheme() {
    const primary = Color(0xFF4D9EFF);

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.dark,
        surface: const Color(0xFF111318),
      ),
      scaffoldBackgroundColor: const Color(0xFF111318),
      cardTheme: CardThemeData(
        elevation: 3,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        scrolledUnderElevation: 1,
        backgroundColor: Color(0xFF111318),
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFFE8EAED),
        ),
        iconTheme: IconThemeData(color: Color(0xFF4D9EFF)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
