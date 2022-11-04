import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/bloc/invite_bloc/invite_bloc.dart';
import 'package:task_manager/bloc/list_bloc/list_bloc.dart';
import 'package:task_manager/bloc/subtask_bloc/subtask_bloc.dart';
import 'package:task_manager/bloc/tag_bloc/tag_bloc.dart';
import 'package:task_manager/models/subtask.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/repository/invite_repository.dart';
import 'package:task_manager/repository/list_repository.dart';
import 'package:task_manager/repository/subtask_repository.dart';
import 'package:task_manager/repository/tag_repository.dart';
import 'package:task_manager/repository/task_repository.dart';
import 'package:task_manager/models/list.dart' as model;

import '../bloc/task_bloc/task_bloc.dart';
import '../models/tag.dart';
import '../providers/constants.dart';

class TaskPage extends StatelessWidget {
  final Task task;

  const TaskPage({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskBloc>(
          create: (context) => TaskBloc(TaskRepository()),
        ),
        BlocProvider<TagBloc>(
          create: (context) => TagBloc(TagRepository()),
        ),
        BlocProvider<ListBloc>(
          create: (context) => ListBloc(ListRepository()),
        ),
        BlocProvider<SubtaskBloc>(
          create: (context) => SubtaskBloc(SubtaskRepository()),
        ),
        BlocProvider<InviteBloc>(
          create: (context) => InviteBloc(InviteRepository()),
        )
      ],
      child: Builder(
        builder: (context) {
          return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              bottomNavigationBar: _bottomNavigationBar(context),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  child: SingleChildScrollView(
                    child: TaskPageContent(
                      context: context,
                      task: task,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void deleteTask(BuildContext context) {
    Widget okButton = TextButton(
      onPressed: () {
        context.read<TaskBloc>().add(DeleteTask(task.id!, []));
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
      child: const Text('Да'),
    );
    AlertDialog alert = AlertDialog(
      title: const Text('Удаление задачи'),
      content: Text.rich(
        TextSpan(
          text: 'Вы уверены, что хотите удалить задачу ',
          children: [
            TextSpan(
              text: task.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      actions: [okButton],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget _navigationBarItem(
    IconData iconData,
    String text,
    Function(BuildContext) onTap,
    BuildContext context,
  ) {
    return InkWell(
      onTap: () => onTap(context),
      child: Row(
        children: [
          Icon(iconData),
          const SizedBox(width: 5),
          Text(text),
        ],
      ),
    );
  }

  Widget? _bottomNavigationBar(BuildContext context) {
    if (user!.id == task.userID) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _navigationBarItem(
              Icons.cancel_outlined,
              'Удалить задачу',
              deleteTask,
              context,
            ),
            _navigationBarItem(
              Icons.check_circle_outline,
              task.isCompleted
                  ? 'Отметить задачу\nактивной'
                  : 'Отметить задачу\nвыполненной',
              (context) {},
              context,
            ),
          ],
        ),
      );
    }
    return null;
  }
}

class TaskPageContent extends StatefulWidget {
  final BuildContext context;
  final Task task;

  const TaskPageContent({Key? key, required this.context, required this.task})
      : super(key: key);

  @override
  State<TaskPageContent> createState() => _TaskPageContentState();
}

class _TaskPageContentState extends State<TaskPageContent> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    descriptionController.text = widget.task.description;
    titleController.text = widget.task.title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(widget.context),
        const SizedBox(height: 15),
        _tagsPanel(widget.context, widget.task),
        const SizedBox(height: 15),
        _actionsPanel(widget.context, widget.task, height, width),
        const SizedBox(height: 15),
        _subtasksPanel(widget.context, widget.task, width, height)
      ],
    );
  }

  Widget _title(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _subtasksPanel(
    BuildContext context,
    Task task,
    double width,
    double height,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title('Подзадачи'),
        const SizedBox(height: 15),
        _subTaskListBuilder(context, task, width, height),
        const SizedBox(height: 15),
        _title('Описание'),
        const SizedBox(height: 15),
        _descriptionField(context)
      ],
    );
  }

  Widget _descriptionField(BuildContext context) {
    return Material(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: descriptionController,
        maxLines: 6,
        decoration: const InputDecoration(
          filled: false,
          label: Text('Описание'),
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _subtaskAddField(
    BuildContext context,
    Task task,
    List<SubTask> subtasks,
  ) {
    TextEditingController controller = TextEditingController();
    return Material(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          hintText: 'Добавить новую подзадачу',
          filled: false,
        ),
        onSubmitted: (String text) {
          context
              .read<SubtaskBloc>()
              .add(CreateSubtask(task.id!, controller.text, subtasks));
          controller.clear();
        },
      ),
    );
  }

  void deleteSubtask(
      BuildContext context, SubTask subTask, List<SubTask> subtasks) {
    Widget okButton = TextButton(
      onPressed: () {
        context.read<SubtaskBloc>().add(DeleteSubtask(subTask.id!, subtasks));
        Navigator.pop(context);
      },
      child: const Text('Да'),
    );
    AlertDialog alert = AlertDialog(
      title: const Text('Удаление подзадачи'),
      content: Text.rich(
        TextSpan(
          text: 'Вы уверены, что хотите удалить подзадачу ',
          children: [
            TextSpan(
              text: subTask.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      actions: [okButton],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget _subTask(
    BuildContext context,
    SubTask subTask,
    List<SubTask> subtasks,
  ) {
    return InkWell(
      onLongPress: () => deleteSubtask(context, subTask, subtasks),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          subTask.title,
          style: TextStyle(
            color: subTask.isCompleted
                ? Theme.of(context).disabledColor
                : Colors.black,
            decoration: subTask.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        leading: Checkbox(
          shape: const CircleBorder(),
          value: subTask.isCompleted,
          onChanged: (bool? value) {
            subTask.isCompleted = !subTask.isCompleted;
            context
                .read<SubtaskBloc>()
                .add(UpdateSubtask(subTask, subTask.id!, subtasks));
          },
        ),
      ),
    );
  }

  Widget _subTaskListBuilder(
    BuildContext context,
    Task task,
    double width,
    double height,
  ) {
    return BlocConsumer<SubtaskBloc, SubtaskState>(
      bloc: context.read<SubtaskBloc>()..add(GetSubtasks(widget.task.id!)),
      listener: (context, state) {
        if (state is SubtaskError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 3),
              content: Text(
                state.message,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is SubtaskLoaded) {
          return _subtaskList(state.subTasks, task);
        } else {
          return _subtaskList([], task);
        }
      },
    );
  }

  Widget _subtaskList(List<SubTask> subtasks, Task task) {
    return Column(
      children: [
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) =>
              _subTask(context, subtasks[index], subtasks),
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemCount: subtasks.length,
        ),
        _subtaskAddField(context, task, subtasks),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextField(
          controller: titleController,
          decoration: const InputDecoration(
            border: InputBorder.none,
            filled: false,
          ),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
          maxLines: null,
        ),
        const SizedBox(height: 15),
        const Text('Дата завершения:'),
        const SizedBox(height: 5),
        Text(DateFormat.yMMMd('ru').format(widget.task.completeDate))
      ],
    );
  }

  Widget _tagsPanel(BuildContext context, Task task) {
    return BlocBuilder<TagBloc, TagState>(
      bloc: context.read<TagBloc>()..add(GetTagsListOfUser(user!.id!)),
      builder: (context, state) {
        if (state is TagListLoaded) {
          return SelectTagPanel(
            task: task,
            context: context,
            userTags: state.tagModel,
          );
        } else if (state is TagLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return SelectTagPanel(
            task: task,
            context: context,
            userTags: [],
          );
        }
      },
    );
  }

  Widget _selectListsView(
    BuildContext context,
    List<model.ListModel> lists,
    Task task,
    double height,
    double width,
    StateSetter stateSetter,
  ) {
    if (lists.isNotEmpty) {
      return ListView.builder(
        itemBuilder: (ctx, index) {
          return CheckboxListTile(
            value: lists[index].tasks.contains(task),
            title: Text(lists[index].title),
            checkboxShape: const CircleBorder(),
            onChanged: (bool) {
              stateSetter(() {
                !lists[index].tasks.contains(task)
                    ? lists[index].tasks.add(task)
                    : lists[index].tasks.remove(task);
              });
              context
                  .read<ListBloc>()
                  .add(UpdateList(lists[index].id!, lists[index]));
            },
          );
        },
        itemCount: lists.length,
      );
    } else {
      return const Center(child: Text('Отсутствуют созданные списки'));
    }
  }

  AlertDialog _alertDialog(
    BuildContext context,
    Task task,
    List<model.ListModel> lists,
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

  void _selectLists(
      BuildContext context, Task task, double height, double width) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocBuilder<ListBloc, ListState>(
          bloc: context.read<ListBloc>()..add(LoadLists(user!.id!)),
          builder: (ctx, state) {
            if (state is ListLoaded) {
              return _alertDialog(context, task, state.list, height, width);
            } else if (state is ListLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return _alertDialog(context, task, [], height, width);
            }
          },
        );
      },
    );
  }

  Widget _actionsPanel(
      BuildContext context, Task task, double height, double width) {
    return Row(
      children: [
        _action(
          Icons.share,
          context,
          task,
          _selectLists,
          'Поделиться\nзадачей',
          width,
          height,
        ),
        const SizedBox(width: 15),
        _action(
          Icons.list_alt_rounded,
          context,
          task,
          _selectLists,
          'Списки',
          width,
          height
        ),
      ],
    );
  }

  Widget _action(
    IconData icon,
    BuildContext context,
    Task task,
    Function(BuildContext, Task, double, double) onTap,
    String text,
    double width,
    double height,
  ) {
    return InkWell(
      onTap: () => onTap(context, task, height, width),
      child: Material(
        elevation: 8.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        child: Container(
          width: width * 0.3,
          height: height * 0.12,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon),
              Text(text),
            ],
          ),
        ),
      ),
    );
  }
}

// TODO: НЕ НРАВИТСЯ, ПЕРЕДЕЛАТЬ, КОДЕР ДЕБИЛ
class SelectTagPanel extends StatefulWidget {
  final Task task;
  final BuildContext context;
  final List<Tag> userTags;

  const SelectTagPanel({
    Key? key,
    required this.task,
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
        .map((tag) => _tag(widget.context, tag, widget.task))
        .toList();
    tags.add(_addTagChip(widget.context, widget.userTags, widget.task));
    return Wrap(spacing: 10, children: List.of(tags));
  }

  Widget _addTagChip(BuildContext context, List<Tag> tags, Task task) {
    return ChoiceChip(
      label: const Text('Добавить тэг'),
      selected: true,
      onSelected: (bool value) {
        _selectTagDialog(context, tags, task);
      },
    );
  }

  void _editTags(
    BuildContext context,
    Task task,
    List<Tag> tags,
    Tag tag,
    StateSetter stateSetter,
    bool selected,
  ) {
    selected ? tags.remove(tag) : tags.add(tag);
    setState(() {});
    stateSetter(() {});
    context.read<TaskBloc>().add(UpdateTask(task.id!, task, []));
  }

  Widget _tagElement(
    BuildContext context,
    Tag tag,
    List<Tag> selectedTags,
    StateSetter stateSetter,
    Task task,
  ) {
    bool selected = selectedTags.contains(tag);
    return ListTile(
      title: Text(tag.title),
      trailing: Checkbox(
        value: selected,
        shape: const CircleBorder(),
        onChanged: (bool? value) {
          _editTags(context, task, selectedTags, tag, stateSetter, selected);
        },
      ),
      leading: CircleAvatar(
        radius: 10,
        backgroundColor: Color(int.parse(tag.color)),
      ),
    );
  }

  Widget _tagsList(BuildContext context, List<Tag> tags, Task task,
      StateSetter stateSetter) {
    if (tags.isNotEmpty) {
      return ListView.builder(
        itemBuilder: (ctx, index) => _tagElement(
          context,
          tags[index],
          task.tags,
          stateSetter,
          task,
        ),
        itemCount: tags.length,
      );
    } else {
      return const Center(child: Text('Отсутствуют созданные категории'));
    }
  }

  void _selectTagDialog(BuildContext context, List<Tag> tags, Task task) {
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
                child: _tagsList(context, tags, task, stateSetter),
              );
            },
          ),
        );
      },
    );
  }

  Widget _tag(BuildContext context, Tag tag, Task task) {
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
          context.read<TaskBloc>().add(UpdateTask(task.id!, task, []));
        });
      },
    );
  }
}
