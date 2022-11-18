import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/task_bloc/task_bloc.dart';
import '../models/tag.dart';
import '../models/task.dart';
import '../providers/constants.dart';

class SelectTagPanel extends StatefulWidget {
  final Task task;
  final List<Task> tasks;
  final BuildContext context;
  final List<Tag> userTags;

  const SelectTagPanel({
    Key? key,
    required this.task,
    required this.tasks,
    required this.context,
    required this.userTags,
  }) : super(key: key);

  @override
  State<SelectTagPanel> createState() => _SelectTagPanelState();
}

class _SelectTagPanelState extends State<SelectTagPanel> {
  @override
  Widget build(BuildContext context) {
    List<Widget> tags = widget.task.tags
        .map((tag) => _tag(widget.context, tag, widget.task, widget.tasks))
        .toList();
    tags.add(_addTagChip(
        widget.context, widget.userTags, widget.task, widget.tasks));
    return Wrap(spacing: 10, children: List.of(tags));
  }

  Widget _addTagChip(
      BuildContext context, List<Tag> tags, Task task, List<Task> tasks) {
    if (task.userID == user!.id!) {
      return ChoiceChip(
        label: const Text('Добавить тэг'),
        selected: true,
        onSelected: (bool value) {
          _selectTagDialog(context, tags, task, tasks);
        },
      );
    }
    return Container();
  }

  void _editTags(
      BuildContext context,
      Task task,
      List<Task> tasks,
      Tag tag,
      List<Tag> tags,
      StateSetter stateSetter,
      bool selected,
      ) {
    selected ? tags.remove(tag) : tags.add(tag);
    setState(() {});
    stateSetter(() {});
    context.read<TaskBloc>().add(UpdateTask(task.id!, task, tasks));
  }

  Widget _tagElement(
      BuildContext context,
      Task task,
      List<Task> tasks,
      Tag tag,
      List<Tag> selectedTags,
      StateSetter stateSetter,
      ) {
    bool selected = selectedTags.contains(tag);
    return ListTile(
      title: Text(tag.title),
      trailing: Checkbox(
        value: selected,
        shape: const CircleBorder(),
        onChanged: (bool? value) {
          _editTags(
            context,
            task,
            tasks,
            tag,
            selectedTags,
            stateSetter,
            selected,
          );
        },
      ),
      leading: CircleAvatar(
        radius: 10,
        backgroundColor: Color(int.parse(tag.color)),
      ),
    );
  }

  Widget _tagsList(
      BuildContext context,
      List<Tag> tags,
      Task task,
      List<Task> tasks,
      StateSetter stateSetter,
      ) {
    if (tags.isNotEmpty) {
      return ListView.builder(
        itemBuilder: (ctx, index) => _tagElement(
          context,
          task,
          tasks,
          tags[index],
          task.tags,
          stateSetter,
        ),
        itemCount: tags.length,
      );
    } else {
      return const Center(
        child: Text(
          'Отсутствуют созданные категории',
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  void _selectTagDialog(
      BuildContext context,
      List<Tag> tags,
      Task task,
      List<Task> tasks,
      ) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Выбор категорий'),
          content: StatefulBuilder(
            builder: (ctx, stateSetter) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width,
                child: _tagsList(context, tags, task, tasks, stateSetter),
              );
            },
          ),
        );
      },
    );
  }

  Widget _tag(BuildContext context, Tag tag, Task task, List<Task> tasks) {
    return RawChip(
      label: Text(tag.title),
      labelStyle: const TextStyle(color: Colors.white),
      showCheckmark: false,
      deleteIcon: const Icon(Icons.cancel_outlined),
      selected: true,
      selectedColor: Color(int.parse(tag.color)),
      onDeleted: () {
        setState(() {
          task.tags.remove(tag);
          context.read<TaskBloc>().add(UpdateTask(task.id!, task, tasks));
        });
      },
    );
  }
}
