class FavoritesState {
  final Set<String> favoriteIds;

  const FavoritesState({this.favoriteIds = const {}});

  FavoritesState copyWith({Set<String>? favoriteIds}) {
    return FavoritesState(favoriteIds: favoriteIds ?? this.favoriteIds);
  }

  bool isFavorite(String url) => favoriteIds.contains(url);
}
