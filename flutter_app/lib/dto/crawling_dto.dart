class CrawlingDto {
  final int crawlingId;
  final String title;
  final String url;
  final String? imageUrl;
  final String description;
  final DateTime? publishedAt;
  final DateTime? crawledAt;

  CrawlingDto({
    required this.crawlingId,
    required this.title,
    required this.url,
    required this.imageUrl,
    required this.description,
    required this.publishedAt,
    required this.crawledAt,
  });

  factory CrawlingDto.fromJson(Map<String, dynamic> json) {
    return CrawlingDto(
      crawlingId: json['crawlingId'],
      title: json['title'],
      url: json['url'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      publishedAt:
          json['publishedAt'] != null
              ? DateTime.parse(json['publishedAt'])
              : null,
      crawledAt:
          json['crawledAt'] != null ? DateTime.parse(json['crawledAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'crawlingId': crawlingId,
      'title': title,
      'url': url,
      'imageUrl': imageUrl,
      'description': description,
      'publishedAt': publishedAt?.toIso8601String(),
      'crawledAt': crawledAt?.toIso8601String(),
    };
  }
}
