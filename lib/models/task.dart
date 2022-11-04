import 'package:task_manager/models/tag.dart';

class Task {
  int? id;
  int userID;
  String title;
  String description;
  DateTime creationDate;
  DateTime completeDate;
  bool isCompleted;
  List<Tag> tags;

  Task({
    this.id,
    required this.userID,
    required this.title,
    required this.description,
    required this.creationDate,
    required this.completeDate,
    required this.isCompleted,
    required this.tags,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json["id"],
      userID: json["userID"],
      title: json["title"],
      description: json["description"],
      creationDate: DateTime.parse(json["creationDate"]),
      completeDate: DateTime.parse(json["completeDate"]),
      isCompleted: json["completed"],
      tags: (json["tags"] as List)
          .map((item) => Tag.fromJson(Map<String, dynamic>.from(item)))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id!,
      "userID": userID,
      "title": title,
      "description": description,
      "creationDate": creationDate.toIso8601String(),
      "completeDate": completeDate.toIso8601String(),
      "completed": isCompleted,
      "tags": List.of(tags).map((e) => e.toJson()).toList()
    };
  }


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Task{id: $id, userID: $userID, title: $title, description: $description, creationDate: $creationDate, completeDate: $completeDate, isCompleted: $isCompleted, tags: $tags}';
  }
}
