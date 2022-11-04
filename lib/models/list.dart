import 'package:intl/intl.dart';

import 'package:task_manager/models/task.dart';

class ListModel {
  int? id;
  int userId;
  String title;
  DateTime completeBy;
  List<Task> tasks;

  ListModel({
    this.id,
    required this.userId,
    required this.title,
    required this.completeBy,
    required this.tasks,
  });

  factory ListModel.fromJson(Map<String, dynamic> json) {
    return ListModel(
      id: json["id"],
      userId: json["createdBy"],
      title: json["title"],
      completeBy: DateFormat("yyyy-MM-dd'T'HH:mm:ssZ").parse(json["completeBy"]),
      tasks: (json["tasks"] as List)
          .map((item) => Task.fromJson(Map<String, dynamic>.from(item)))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "createdBy": userId,
      "title": title,
      "completeBy": completeBy.toIso8601String(),
      "tasks": List.of(tasks).map((e) => e.toJson()).toList()
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

//

}
