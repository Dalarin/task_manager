import 'package:task_manager/models/task.dart';

class SubTask {
  int? id;
  Task? task;
  String title;
  bool isCompleted;

  SubTask({this.id, this.task, required this.title, this.isCompleted = false});

  factory SubTask.fromJson(Map<String, dynamic> json) {
    return SubTask(
      id: json["id"],
      title: json["title"],
      isCompleted: json["completed"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "task": {
        "id": task?.id ?? 0
      },
      "title": title,
      "completed": isCompleted
    };
  }





  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubTask && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
