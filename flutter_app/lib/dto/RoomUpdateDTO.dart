class RoomUpdateDTO {
  String? title;
  String? description;
  int? capacity;

  RoomUpdateDTO({this.title, this.description, this.capacity});

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    if (title != null) data['title'] = title;
    if (description != null) data['description'] = description;
    if (capacity != null) data['capacity'] = capacity;

    return data;
  }
}
