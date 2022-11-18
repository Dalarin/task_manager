

import 'package:task_manager/models/list.dart';
import 'package:task_manager/models/user.dart';

class ListInvite {
  int? id;
  ListModel listModel;
  User? user;
  DateTime inviteDate;

  ListInvite({
    this.id,
    required this.listModel,
    this.user,
    required this.inviteDate,
  });

  factory ListInvite.fromJson(Map<String, dynamic> json) {
    return ListInvite(
      id: json["id"],
      user: User.fromJson(json["user"]),
      listModel: ListModel.fromJson(json["list"]),
      inviteDate: DateTime.parse(json["inviteDate"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "list": listModel.toJson(),
      "invitedBy": user!.toJson(),
      "inviteDate": inviteDate.toIso8601String(),
    };
  }

  Map<String, dynamic> toJsonCreation() {
    return {
      "id": id,
      "list": listModel.toJson(),
      "user": {},
      "invitedBy": user!.toJson(),
      "inviteDate": inviteDate.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ListInvite && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
