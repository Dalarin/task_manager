import 'package:task_manager/models/subtask.dart';
import 'package:task_manager/models/tag.dart';


class Task {
  int? id;
  int userID;
  String title;
  String description;
  DateTime creationDate;
  DateTime completeDate;
  bool isCompleted;
  List<Tag> tags = [];
  List<SubTask> subTasks = [];

  Task({
    this.id,
    required this.userID,
    required this.title,
    required this.description,
    required this.creationDate,
    required this.completeDate,
    required this.isCompleted,
    this.tags = const [],
    this.subTasks = const [],
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    final tags = (json["tags"] as List);
    final subTasks = json["subTasks"] as List;
    return Task(
      id: json["id"],
      userID: json["userID"],
      title: json["title"],
      description: json["description"],
      creationDate: DateTime.parse(json["creationDate"]),
      completeDate: DateTime.parse(json["completeDate"]),
      isCompleted: json["completed"],
      tags:
          tags.map((e) => Tag.fromJson(Map<String, dynamic>.from(e))).toList(),
      subTasks: subTasks
          .map((e) => SubTask.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id ?? 0,
      "userID": userID,
      "title": title,
      "description": description,
      "creationDate": creationDate.toIso8601String(),
      "completeDate": completeDate.toIso8601String(),
      "completed": isCompleted,
      "tags": List.of(tags).map((e) => e.toJson()).toList(),
      "subTasks": List.of(subTasks).map((e) => e.toJson()).toList(),
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
    return 'Task{id: $id, userID: $userID, title: $title, description: $description, creationDate: $creationDate, completeDate: $completeDate, isCompleted: $isCompleted, tags: $tags, subTasks: $subTasks}';
  }
}
