import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:news_app/features/articles/data/repositories/articles_repository.dart';

import 'articles_state.dart';

class ArticlesCubit extends Cubit<ArticlesState> {
  final ArticlesRepository _repository;

  ArticlesCubit(this._repository) : super(const ArticlesState());

  Future<void> loadArticles() async {
    if (state.isLoading) return;

    emit(
      state.copyWith(
        isLoading: true,
        clearError: true,
        articles: [],
        page: 1,
        reachedEnd: false,
      ),
    );

    try {
      final articles = await _repository.fetchArticles(1);
      emit(
        state.copyWith(
          articles: articles,
          isLoading: false,
          page: 1,
          reachedEnd: articles.isEmpty,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Failed to load articles. Please try again.',
        ),
      );
    }
  }

  Future<void> loadMoreArticles() async {
    if (state.loadingNextPage || state.reachedEnd || state.isLoading) return;

    emit(state.copyWith(loadingNextPage: true));

    try {
      final nextPage = state.page + 1;
      final articles = await _repository.fetchArticles(nextPage);

      if (articles.isEmpty) {
        emit(state.copyWith(loadingNextPage: false, reachedEnd: true));
      } else {
        emit(
          state.copyWith(
            articles: [...state.articles, ...articles],
            loadingNextPage: false,
            page: nextPage,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(loadingNextPage: false));
    }
  }
}
