
class Mentor {
  final String name;
  final String description;
  final String imageUrl;

  Mentor({
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  factory Mentor.fromJson(Map<String, dynamic> json) {
    return Mentor(
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }
}
