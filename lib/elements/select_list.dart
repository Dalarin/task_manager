import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/list_bloc/list_bloc.dart';
import '../models/list.dart';
import '../models/task.dart';
import '../providers/constants.dart';

class SelectListDialog extends StatelessWidget {
  final BuildContext context;
  final Task task;
  final List<Task> tasks;
  final double height;
  final double width;

  const SelectListDialog({
    Key? key,
    required this.context,
    required this.task,
    required this.tasks,
    required this.height,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListBloc, ListState>(
      bloc: this.context.read<ListBloc>()..add(LoadLists(user!.id!)),
      builder: (ctx, state) {
        if (state is ListLoaded) {
          return _selectListsAlertDialog(
            this.context,
            task,
            state.list,
            height,
            width,
          );
        } else if (state is ListLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return _selectListsAlertDialog(this.context, task, [], height, width);
        }
      },
    );
  }

  Widget _selectList(
    BuildContext context,
    ListModel listModel,
    bool value,
    Task task,
    StateSetter stateSetter,
  ) {
    return CheckboxListTile(
      title: Text(listModel.title),
      checkboxShape: const CircleBorder(),
      value: value,
      onChanged: (bool? value) {
        stateSetter(() {
          if (listModel.tasks.contains(task)) {
            listModel.tasks.remove(task);
          } else {
            listModel.tasks.add(task);
          }
        });
        final cubit = context.read<ListBloc>();
        cubit.add(AddListToTask(listModel: listModel));
      },
    );
  }

  Widget _selectListsView(
    BuildContext context,
    List<ListModel> lists,
    Task task,
    double height,
    double width,
    StateSetter stateSetter,
  ) {
    if (lists.isNotEmpty) {
      return ListView.builder(
        itemBuilder: (ctx, index) {
          bool value = lists[index].tasks.contains(task);
          return _selectList(context, lists[index], value, task, stateSetter);
        },
        itemCount: lists.length,
      );
    } else {
      return const Center(child: Text('Отсутствуют созданные списки'));
    }
  }

  AlertDialog _selectListsAlertDialog(
    BuildContext context,
    Task task,
    List<ListModel> lists,
    double height,
    double width,
  ) {
    return AlertDialog(
      title: const Text('Выбор списков'),
      content: StatefulBuilder(
        builder: (ctx, stateSetter) {
          return SizedBox(
            height: height * 0.5,
            width: width * 0.75,
            child: _selectListsView(
              context,
              lists,
              task,
              height,
              width,
              stateSetter,
            ),
          );
        },
      ),
    );
  }
}
