import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/elements/task_list.dart';

import '../bloc/task_bloc/task_bloc.dart';
import '../providers/constants.dart';
import '../repository/task_repository.dart';
import 'loading_element.dart';

class ListOfTasks extends StatelessWidget {
  final double finalHeight;
  final double boxSize;

  const ListOfTasks({
    Key? key,
    required this.finalHeight,
    required this.boxSize,
  }) : super(key: key);

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
                boxSize: boxSize,
              );
            } else if (state is TaskError) {
              return Text(state.message);
            } else if (state is TaskListLoaded) {
              return TaskList(
                ctx: context,
                tasks: state.list,
                width: width,
                height: height,
                finalHeight: finalHeight,
              );
            } else {
              return TaskList(
                ctx: context,
                tasks: const [],
                width: width,
                height: height,
                finalHeight: finalHeight,
              );
            }
          },
        ),
      ),
    );
  }
}
