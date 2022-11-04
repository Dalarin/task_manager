class SubTask {
  int? id;
  int taskId;
  String title;
  bool isCompleted;

  SubTask({this.id, required this.taskId, required this.title, required this.isCompleted});

  factory SubTask.fromJson(Map<String, dynamic> json) {
    return SubTask(
      id: json["id"],
      taskId: json["taskID"],
      title: json["title"],
      isCompleted: json["completed"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "taskID": taskId,
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
