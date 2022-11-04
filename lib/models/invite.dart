import 'package:task_manager/models/task.dart';
import 'package:task_manager/models/user.dart';

class Invite {
  int? id;
  Task task;
  User user;
  DateTime inviteDate;

  Invite({
    this.id,
    required this.task,
    required this.user,
    required this.inviteDate,
  });

  factory Invite.fromJson(Map<String, dynamic> json) {
    return Invite(
      id: json["id"],
      task: Task.fromJson(json["task"]),
      user: User.fromJson(json["user"]),
      inviteDate: DateTime.parse(json["inviteDate"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "task": task.toJson(),
      "user": user.toJson(),
      "inviteDate": inviteDate.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Invite && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
