class Tag {
  int? id;
  int userId;
  String title;
  String color;

  Tag({
    this.id,
    required this.userId,
    required this.title,
    required this.color,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: int.parse(json["id"]),
      userId: int.parse(json["userId"]),
      title: json["title"],
      color: json["color"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "title": title,
      "color": color,
    };
  }
}
