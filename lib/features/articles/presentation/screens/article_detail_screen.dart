import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:news_app/features/articles/data/models/article_model.dart';
import 'package:news_app/features/articles/presentation/cubit/favorites_cubit.dart';
import 'package:news_app/features/articles/presentation/cubit/favorites_state.dart';

class ArticleDetailScreen extends StatelessWidget {
  final ArticleModel article;

  const ArticleDetailScreen({super.key, required this.article});

  String _formatDate(String raw) {
    try {
      final dt = DateTime.parse(raw);
      return DateFormat('MMMM d, yyyy • h:mm a').format(dt.toLocal());
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(colors, context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: _buildArticleContent(theme, colors),
            ),
          ),
        ],
      ),
      floatingActionButton: _BookmarkButton(articleUrl: article.url),
    );
  }

  SliverAppBar _buildSliverAppBar(ColorScheme colors, BuildContext context) {
    return SliverAppBar(
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      expandedHeight: 280,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: _HeroImage(imageUrl: article.urlToImage, colors: colors),
      ),
    );
  }

  Widget _buildArticleContent(ThemeData theme, ColorScheme colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (article.sourceName.isNotEmpty) ...[
          _SourceTag(name: article.sourceName, theme: theme, colors: colors),
          const SizedBox(height: 14),
        ],
        Text(
          article.title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 10),
        _DateRow(
          date: _formatDate(article.publishedAt),
          colors: colors,
          theme: theme,
        ),
        if (article.description != null && article.description!.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            article.description!,
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.65,
              color: colors.onSurface.withValues(alpha: 0.82),
            ),
          ),
        ],
      ],
    );
  }
}

class _HeroImage extends StatelessWidget {
  final String? imageUrl;
  final ColorScheme colors;

  const _HeroImage({required this.imageUrl, required this.colors});

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return Container(
        color: colors.surfaceContainerHighest,
        child: Center(
          child: Icon(
            Icons.article_rounded,
            size: 72,
            color: colors.onSurfaceVariant,
          ),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: colors.surfaceContainerHighest,
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (context, url, error) => Container(
        color: colors.surfaceContainerHighest,
        child: Icon(
          Icons.image_not_supported_rounded,
          size: 64,
          color: colors.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _SourceTag extends StatelessWidget {
  final String name;
  final ThemeData theme;
  final ColorScheme colors;

  const _SourceTag({
    required this.name,
    required this.theme,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        name,
        style: theme.textTheme.labelMedium?.copyWith(
          color: colors.onPrimaryContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _DateRow extends StatelessWidget {
  final String date;
  final ColorScheme colors;
  final ThemeData theme;

  const _DateRow({
    required this.date,
    required this.colors,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.schedule_rounded,
          size: 13,
          color: colors.onSurface.withValues(alpha: 0.45),
        ),
        const SizedBox(width: 5),
        Text(
          date,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colors.onSurface.withValues(alpha: 0.45),
          ),
        ),
      ],
    );
  }
}

class _BookmarkButton extends StatelessWidget {
  final String articleUrl;

  const _BookmarkButton({required this.articleUrl});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        final saved = state.isFavorite(articleUrl);
        return FloatingActionButton.extended(
          onPressed: () {
            final cubit = context.read<FavoritesCubit>();
            saved
                ? cubit.removeFavorite(articleUrl)
                : cubit.addFavorite(articleUrl);
          },
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: Icon(
              saved ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
              key: ValueKey(saved),
            ),
          ),
          label: Text(saved ? 'Saved' : 'Save'),
        );
      },
    );
  }
}
