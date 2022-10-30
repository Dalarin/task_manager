import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/elements/task_element.dart';

import '../bloc/task_bloc/task_bloc.dart';
import '../models/task.dart';
import '../providers/constants.dart';
import '../repository/task_repository.dart';
import 'loading_element.dart';

class ListOfTasks extends StatelessWidget {
  const ListOfTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BlocProvider<TaskBloc>(
      create: (context) =>
          TaskBloc(TaskRepository())..add(GetTaskList(user!.id!)),
      child: BlocListener<TaskBloc, TaskState>(
        listener: (context, state) {},
        child: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state is TaskLoading) {
              return LoadingElement(
                height: height * 0.1,
                width: width * 0.45,
                scrollDirection: Axis.vertical,
              );
            } else if (state is TaskError) {
              return Text(state.message);
            } else if (state is TaskListLoaded) {
              return _taskListView(context, state.list, width, height);
            } else {
              return _taskListView(context, [], width, height);
            }
          },
        ),
      ),
    );
  }

  Widget _taskListView(
      BuildContext context, List<Task> tasks, double width, double height) {
    if (tasks.isNotEmpty) {
      return SizedBox(
        height: height * 0.3,
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) => TaskElement(task: tasks[index]),
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
