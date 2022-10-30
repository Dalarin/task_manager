class Task {
  int? id;
  int userID;
  String title;
  String description;
  DateTime creationDate;
  DateTime completeDate;
  bool isCompleted;

  Task(
      {this.id,
      required this.userID,
      required this.title,
      required this.description,
      required this.creationDate,
      required this.completeDate,
      required this.isCompleted});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json["id"],
      userID: json["userID"],
      title: json["title"],
      description: json["description"],
      creationDate: DateTime.parse(json["creationDate"]),
      completeDate: DateTime.parse(json["completeDate"]),
      isCompleted: json["isCompleted"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userID": userID,
      "title": title,
      "description": description,
      "creationDate": creationDate.toIso8601String(),
      "completeDate": completeDate.toIso8601String(),
      "isCompleted": isCompleted,
    };
  }


//

}
