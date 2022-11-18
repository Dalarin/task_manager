import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';
import 'package:task_manager/bloc/task_bloc/task_bloc.dart';
import 'package:task_manager/elements/loading_element.dart';
import 'package:task_manager/elements/task_list.dart';
import 'package:task_manager/page/create_task_page.dart';
import 'package:task_manager/repository/task_repository.dart';

import '../providers/constants.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BlocProvider<TaskBloc>(
      create: (context) => TaskBloc(TaskRepository()),
      child: Builder(
        builder: (ctx) {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                  child: Column(
                    children: [
                      _header(ctx),
                      _calendar(ctx),
                      _listView(ctx, height, width),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _listView(BuildContext context, double height, double width) {
    return BlocBuilder<TaskBloc, TaskState>(
      bloc: context.read<TaskBloc>(),
      builder: (context, state) {
        if (state is TaskLoading) {
          return LoadingElement(
            height: height * 0.1,
            width: width,
            scrollDirection: Axis.vertical,
            boxSize: height,
          );
        } else if (state is TaskListLoaded) {
          return TaskList(
            tasks: state.list,
            width: width,
            height: height,
            finalHeight: 0.63,
          );
        } else {
          return TaskList(
            tasks: const [],
            width: width,
            height: height,
            finalHeight: 0.63,
          );
        }
      },
    );
  }

  Widget _calendar(BuildContext ctx) {
    return CalendarTimeline(
      showYears: false,
      initialDate: DateTime.now(),
      firstDate: DateTime(2013),
      lastDate: DateTime(2030),
      onDateSelected: (DateTime selectedDate) {
        ctx.read<TaskBloc>().add(DayOfTasksSelected(selectedDate, user!.id!));
      },
    );
  }

  Widget _header(BuildContext ctx) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DateFormat.yMMMM('ru').format(DateTime.now()),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        _createTaskButton(ctx)
      ],
    );
  }

  Widget _createTaskButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreateTaskPage()),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.35,
        height: MediaQuery.of(context).size.height * 0.05,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        alignment: Alignment.center,
        child: const Text(
          ' + Создать задачу',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
