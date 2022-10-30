import 'package:flutter/material.dart';
import 'package:task_manager/models/task.dart';
import 'package:intl/intl.dart';

class TaskElement extends StatelessWidget {
  final Task task;

  const TaskElement({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Material(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        width: width,
        height: height * 0.1,
        child: ListTile(
          onTap: () {},
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            task.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(DateFormat.yMMMMd('ru').format(task.completeDate)),
          trailing: const InkWell(
            child: Icon(
              Icons.more_vert,
              color: Color(0xFF3B378E),
            ),
          ),
          leading: CircleAvatar(
            backgroundColor: Color(0xFF3B378E),
            radius: height * 0.03,
            child: Icon(Icons.ballot_rounded),
          ),
        ),
      ),
    );
  }
}
