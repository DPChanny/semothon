class CrawlingInfoDto {
  final int crawlingId;
  final String title;
  final String url;
  final String imageUrl;
  final String description;
  final DateTime deadlinedAt;
  final DateTime crawledAt;
  final List<int> chatRoomsId;
  final List<String> interests;

  CrawlingInfoDto({
    required this.crawlingId,
    required this.title,
    required this.url,
    required this.imageUrl,
    required this.description,
    required this.deadlinedAt,
    required this.crawledAt,
    required this.chatRoomsId,
    required this.interests,
  });

  factory CrawlingInfoDto.fromJson(Map<String, dynamic> json) {
    return CrawlingInfoDto(
      crawlingId: json['crawlingId'],
      title: json['title'],
      url: json['url'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      deadlinedAt: DateTime.parse(json['deadlinedAt'] ?? "2025-10-09T02:45:00"),
      crawledAt: DateTime.parse(json['crawledAt']),
      chatRoomsId: List<int>.from(json['chatRoomsId']),
      interests: List<String>.from(json['interests']),
    );
  }
}
