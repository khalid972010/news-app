import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:news_app/features/articles/data/models/article_model.dart';
import 'package:news_app/features/articles/presentation/cubit/articles_cubit.dart';
import 'package:news_app/features/articles/presentation/cubit/articles_state.dart';
import 'package:news_app/features/articles/presentation/widgets/article_item.dart';
import 'package:news_app/features/articles/presentation/widgets/error_state_widget.dart';
import 'package:news_app/features/articles/presentation/widgets/loading_indicator.dart';

import 'article_detail_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<ArticlesCubit>().loadArticles();
  }

  void _onScroll() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 300) {
      context.read<ArticlesCubit>().loadMoreArticles();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: BlocBuilder<ArticlesCubit, ArticlesState>(
        builder: (context, state) => _buildBody(context, state),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'News & Insight',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.bookmark_rounded),
          tooltip: 'Saved articles',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FavoritesScreen()),
          ),
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildBody(BuildContext context, ArticlesState state) {
    if (state.isLoading) return const LoadingIndicator();

    if (state.error != null && state.articles.isEmpty) {
      return ErrorStateWidget(
        message: state.error!,
        onRetry: () => context.read<ArticlesCubit>().loadArticles(),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<ArticlesCubit>().loadArticles(),
      child: _ArticlesList(scrollController: _scrollController, state: state),
    );
  }
}

class _ArticlesList extends StatelessWidget {
  final ScrollController scrollController;
  final ArticlesState state;

  const _ArticlesList({required this.scrollController, required this.state});

  @override
  Widget build(BuildContext context) {
    final itemCount = state.articles.length + (state.loadingNextPage ? 1 : 0);

    return ListView.builder(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index == state.articles.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: LoadingIndicator(),
          );
        }

        return _ArticleRow(article: state.articles[index]);
      },
    );
  }
}

class _ArticleRow extends StatelessWidget {
  final ArticleModel article;

  const _ArticleRow({required this.article});

  @override
  Widget build(BuildContext context) {
    return ArticleItem(
      article: article,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ArticleDetailScreen(article: article),
        ),
      ),
    );
  }
}
