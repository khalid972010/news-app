import '../datasources/articles_remote_datasource.dart';
import '../datasources/favorites_local_datasource.dart';
import '../models/article_model.dart';

class ArticlesRepository {
  final ArticlesRemoteDatasource _remote;
  final FavoritesLocalDatasource _local;

  ArticlesRepository(this._remote, this._local);

  Future<List<ArticleModel>> fetchArticles(int page) {
    return _remote.fetchArticles(page);
  }

  List<String> getFavoriteIds() {
    return _local.getFavoriteIds();
  }

  Future<void> saveFavoriteIds(List<String> ids) {
    return _local.saveFavoriteIds(ids);
  }
}
