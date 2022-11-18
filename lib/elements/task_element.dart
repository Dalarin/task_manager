import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/page/task_page.dart';
import 'package:task_manager/providers/constants.dart';

import '../bloc/task_bloc/task_bloc.dart';
import '../models/tag.dart';

class TaskElement extends StatelessWidget {
  final Task task;
  final List<Task> tasks;

  const TaskElement({
    Key? key,
    required this.task,
    required this.tasks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) {
              return BlocProvider.value(
                value: context.read<TaskBloc>(),
                child: TaskPage(
                  tasks: tasks,
                  task: task,
                ),
              );
            },
          ),
        );
      },
      child: Material(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.1,
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  task.title.trim(),
                  style: TextStyle(
                    color: task.isCompleted
                        ? Theme.of(context).disabledColor
                        : Colors.black,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat.yMMMMd('ru').format(task.completeDate),
                  style: TextStyle(
                    color: task.isCompleted
                        ? Theme.of(context).disabledColor
                        : Colors.black,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                )
              ],
            ),
            subtitle: tagsWidget(),
            trailing: const InkWell(
              child: Icon(
                Icons.more_vert,
                color: Color(0xFF3B378E),
              ),
            ),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              radius: MediaQuery.of(context).size.height * 0.03,
              child: Icon(
                task.isCompleted
                    ? Icons.check_circle_outline
                    : Icons.ballot_rounded,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget tag(Tag tag) {
    return CircleAvatar(
      radius: 5.0,
      backgroundColor: Color(
        int.parse(tag.color),
      ),
    );
  }

  Widget tagsWidget() {
    return Wrap(
      spacing: 2,
      children: task.tags.map((e) => tag(e)).toList(),
    );
  }
}
