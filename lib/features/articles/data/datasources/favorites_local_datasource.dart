import 'package:news_app/core/constants/constants.dart';
import 'package:news_app/core/storage/local_storage.dart';

class FavoritesLocalDatasource {
  List<String> getFavoriteIds() {
    return LocalStorage.getStringList(AppConstants.favoritesKey);
  }

  Future<void> saveFavoriteIds(List<String> ids) async {
    await LocalStorage.setStringList(AppConstants.favoritesKey, ids);
  }
}
