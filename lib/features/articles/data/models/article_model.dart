class ArticleModel {
  final String title;
  final String? description;
  final String? urlToImage;
  final String publishedAt;
  final String sourceName;
  final String url;

  ArticleModel({
    required this.title,
    this.description,
    this.urlToImage,
    required this.publishedAt,
    required this.sourceName,
    required this.url,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      urlToImage: json['urlToImage'] as String?,
      publishedAt: json['publishedAt'] as String? ?? '',
      sourceName:
          (json['source'] as Map<String, dynamic>?)?['name'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }
}
