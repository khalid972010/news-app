import 'package:news_app/core/constants/constants.dart';
import 'package:news_app/core/network/api_service.dart';
import '../models/article_model.dart';

class ArticlesRemoteDatasource {
  final ApiService _apiService;

  ArticlesRemoteDatasource(this._apiService);

  Future<List<ArticleModel>> fetchArticles(int page) async {
    final response = await _apiService.get(
      '/top-headlines',
      queryParameters: {
        'country': 'us',
        'page': page,
        'pageSize': AppConstants.pageSize,
        'apiKey': AppConstants.apiKey,
      },
    );

    final articles = (response.data['articles'] as List<dynamic>)
        .map((e) => ArticleModel.fromJson(e as Map<String, dynamic>))
        .where((a) => a.title.isNotEmpty && a.url.isNotEmpty)
        .toList();

    return articles;
  }
}
