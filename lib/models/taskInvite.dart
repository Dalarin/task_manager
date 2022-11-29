import 'package:task_manager/models/task.dart';
import 'package:task_manager/models/user.dart';

class TaskInvite {
  int? id;
  Task task;
  User? user;
  User invitedBy;
  DateTime inviteDate;

  TaskInvite({
    this.id,
    required this.task,
    required this.invitedBy,
    this.user,
    required this.inviteDate,
  });

  factory TaskInvite.fromJson(Map<String, dynamic> json) {
    return TaskInvite(
      id: json["id"],
      user: User.fromJson(json["user"]),
      invitedBy: User.fromJson(json["invitedBy"]),
      task: Task.fromJson(json["task"]),
      inviteDate: DateTime.parse(json["inviteDate"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "task": task.toJson(),
      "user": user!.toJson(),
      "invitedBy": user!.toJson(),
      "inviteDate": inviteDate.toIso8601String(),
    };
  }

  Map<String, dynamic> toJsonCreation() {
    return {
      "id": id,
      "task": task.toJson(),
      "user": {},
      "invitedBy": user!.toJson(),
      "inviteDate": inviteDate.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskInvite && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
