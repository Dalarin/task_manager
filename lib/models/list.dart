import 'package:intl/intl.dart';

class List {
  int? id;
  int userId;
  String title;
  DateTime completeBy;

  List({
    this.id,
    required this.userId,
    required this.title,
    required this.completeBy,
  });

  factory List.fromJson(Map<String, dynamic> json) {
    return List(
      id: json["id"],
      userId: json["createdBy"],
      title: json["title"],
      completeBy: DateFormat("yyyy-MM-dd'T'HH:mm:ssZ").parse(json["completeBy"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "createdBy": userId,
      "title": title,
      "completeBy": completeBy.toIso8601String(),
    };
  }

//

}
