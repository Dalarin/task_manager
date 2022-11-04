
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
      id: json["id"],
      userId: json["userId"],
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tag && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}


