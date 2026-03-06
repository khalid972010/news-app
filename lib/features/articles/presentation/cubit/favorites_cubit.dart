import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/articles/data/repositories/articles_repository.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final ArticlesRepository _repository;

  FavoritesCubit(this._repository) : super(const FavoritesState());

  void loadFavorites() {
    final ids = _repository.getFavoriteIds();
    emit(FavoritesState(favoriteIds: ids.toSet()));
  }

  Future<void> addFavorite(String url) async {
    final updated = {...state.favoriteIds, url};
    emit(state.copyWith(favoriteIds: updated));
    await _repository.saveFavoriteIds(updated.toList());
  }

  Future<void> removeFavorite(String url) async {
    final updated = {...state.favoriteIds}..remove(url);
    emit(state.copyWith(favoriteIds: updated));
    await _repository.saveFavoriteIds(updated.toList());
  }

  bool isFavorite(String url) => state.isFavorite(url);
}
