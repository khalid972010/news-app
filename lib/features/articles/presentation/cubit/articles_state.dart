import 'package:news_app/features/articles/data/models/article_model.dart';

class ArticlesState {
  final List<ArticleModel> articles;
  final bool isLoading;
  final bool loadingNextPage;
  final bool reachedEnd;
  final String? error;
  final int page;

  const ArticlesState({
    this.articles = const [],
    this.isLoading = false,
    this.loadingNextPage = false,
    this.reachedEnd = false,
    this.error,
    this.page = 1,
  });

  ArticlesState copyWith({
    List<ArticleModel>? articles,
    bool? isLoading,
    bool? loadingNextPage,
    bool? reachedEnd,
    String? error,
    int? page,
    bool clearError = false,
  }) {
    return ArticlesState(
      articles: articles ?? this.articles,
      isLoading: isLoading ?? this.isLoading,
      loadingNextPage: loadingNextPage ?? this.loadingNextPage,
      reachedEnd: reachedEnd ?? this.reachedEnd,
      error: clearError ? null : error ?? this.error,
      page: page ?? this.page,
    );
  }
}
