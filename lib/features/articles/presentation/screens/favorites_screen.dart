import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:news_app/features/articles/data/models/article_model.dart';
import 'package:news_app/features/articles/presentation/cubit/articles_cubit.dart';
import 'package:news_app/features/articles/presentation/cubit/articles_state.dart';
import 'package:news_app/features/articles/presentation/cubit/favorites_cubit.dart';
import 'package:news_app/features/articles/presentation/cubit/favorites_state.dart';
import 'package:news_app/features/articles/presentation/widgets/article_item.dart';

import 'article_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Saved Articles',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, favState) {
          return BlocBuilder<ArticlesCubit, ArticlesState>(
            builder: (context, articlesState) {
              final saved = articlesState.articles
                  .where((a) => favState.isFavorite(a.url))
                  .toList();

              if (saved.isEmpty) return const _EmptyState();

              return _SavedList(articles: saved);
            },
          );
        },
      ),
    );
  }
}

class _SavedList extends StatelessWidget {
  final List<ArticleModel> articles;

  const _SavedList({required this.articles});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return ArticleItem(
          article: article,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ArticleDetailScreen(article: article),
            ),
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bookmark_border_rounded,
              size: 72,
              color: colors.onSurface.withValues(alpha: 0.25),
            ),
            const SizedBox(height: 16),
            Text(
              'Nothing saved yet',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colors.onSurface.withValues(alpha: 0.5),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the Save button on any article to bookmark it.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.onSurface.withValues(alpha: 0.4),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
