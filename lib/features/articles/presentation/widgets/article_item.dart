import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:news_app/features/articles/data/models/article_model.dart';

class ArticleItem extends StatelessWidget {
  final ArticleModel article;
  final VoidCallback onTap;

  const ArticleItem({super.key, required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shadowColor: colors.shadow.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colors.outline.withValues(alpha: 0.1)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildImage(colors), _buildContent(theme, colors)],
        ),
      ),
    );
  }

  Widget _buildImage(ColorScheme colors) {
    if (article.urlToImage == null) {
      return Container(
        height: 120,
        color: colors.surfaceContainerHighest,
        child: Center(
          child: Icon(
            Icons.article_rounded,
            size: 48,
            color: colors.onSurfaceVariant,
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: CachedNetworkImage(
        imageUrl: article.urlToImage!,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: colors.surfaceContainerHighest,
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        errorWidget: (context, url, error) => Container(
          color: colors.surfaceContainerHighest,
          child: Icon(
            Icons.image_not_supported_rounded,
            color: colors.onSurfaceVariant,
            size: 40,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme, ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (article.sourceName.isNotEmpty) ...[
            _SourceBadge(
              name: article.sourceName,
              theme: theme,
              colors: colors,
            ),
            const SizedBox(height: 8),
          ],
          Text(
            article.title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              height: 1.35,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (article.description != null &&
              article.description!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              article.description!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.onSurface.withValues(alpha: 0.6),
                height: 1.45,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

class _SourceBadge extends StatelessWidget {
  final String name;
  final ThemeData theme;
  final ColorScheme colors;

  const _SourceBadge({
    required this.name,
    required this.theme,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        name,
        style: theme.textTheme.labelSmall?.copyWith(
          color: colors.onPrimaryContainer,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
