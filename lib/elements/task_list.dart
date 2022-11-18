import 'package:flutter/material.dart';
import 'package:task_manager/elements/task_element.dart';

import '../models/task.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final double finalHeight;
  final double width;
  final double height;

  const TaskList({
    Key? key,
    required this.tasks,
    required this.width,
    required this.height,
    required this.finalHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _body(context);
  }

  Widget _body(BuildContext context) {
    if (tasks.isNotEmpty) {
      return SizedBox(
        height: height * finalHeight,
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (_, index) => TaskElement(
            task: tasks[index],
            tasks: tasks,
          ),
          separatorBuilder: (context, index) => const SizedBox(height: 15),
          itemCount: tasks.length,
        ),
      );
    } else {
      return Material(
        elevation: 5.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          height: height * 0.25,
          width: width,
          child: const Text(
            'Отсутствуют созданные задания. Перейдите на вкладку Календарь и создайте новое задание',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }
}
