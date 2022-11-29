import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/bloc/invite_bloc/invite_bloc.dart';
import 'package:task_manager/bloc/list_bloc/list_bloc.dart';
import 'package:task_manager/bloc/subtask_bloc/subtask_bloc.dart';
import 'package:task_manager/bloc/tag_bloc/tag_bloc.dart';
import 'package:task_manager/elements/select_list.dart';
import 'package:task_manager/elements/select_tags.dart';
import 'package:task_manager/elements/share_task.dart';
import 'package:task_manager/elements/users_in_task.dart';
import 'package:task_manager/models/subtask.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/repository/invite_repository.dart';
import 'package:task_manager/repository/list_repository.dart';
import 'package:task_manager/repository/subtask_repository.dart';
import 'package:task_manager/repository/tag_repository.dart';

import '../bloc/task_bloc/task_bloc.dart';
import '../bloc/user_bloc/user_bloc.dart';
import '../providers/constants.dart';
import '../repository/user_repository.dart';

class TaskPage extends StatelessWidget {
  final Task task;
  final List<Task> tasks;

  const TaskPage({
    Key? key,
    required this.tasks,
    required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TagBloc>(
          create: (context) => TagBloc(TagRepository()),
        ),
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(UserRepository()),
        ),
        BlocProvider<SubtaskBloc>(
          create: (context) => SubtaskBloc(SubtaskRepository()),
        ),
        BlocProvider<ListBloc>(
          create: (context) => ListBloc(ListRepository()),
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
              bottomNavigationBar: _bottomNavigationBar(
                context,
                task,
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  child: SingleChildScrollView(
                    child: TaskPageContent(
                      task: task,
                      tasks: tasks,
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
        final cubit = context.read<TaskBloc>();
        cubit.add(DeleteTask(task.id!, tasks));
        Navigator.pop(context);
        Future.delayed(
          const Duration(milliseconds: 500),
          () => Navigator.pop(context),
        );
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
    BuildContext taskContext,
  ) {
    return InkWell(
      onTap: () => onTap(taskContext),
      child: Row(
        children: [
          Icon(iconData),
          const SizedBox(width: 5),
          Text(text),
        ],
      ),
    );
  }

  Widget? _bottomNavigationBar(BuildContext context, Task task) {
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
              (context) {
                // TODO: разобраться
                final cubit = context.read<TaskBloc>();
                task.isCompleted = !task.isCompleted;
                cubit.add(UpdateTask(task.id!, task, tasks));
                Future.delayed(
                  const Duration(milliseconds: 500),
                  () => Navigator.pop(context),
                );
              },
              context,
            ),
          ],
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 15,
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              final bloc = context.read<UserBloc>();
              bloc.add(DeleteUserFromTask(taskId: task.id!, userId: user!.id!));
              Future.delayed(
                const Duration(milliseconds: 500),
                () => Navigator.pop(context),
              );
            },
            child: Row(
              children: const [
                Icon(Icons.exit_to_app),
                SizedBox(width: 5),
                Text('Выйти из задачи'),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TaskPageContent extends StatelessWidget {
  final Task task;
  final List<Task> tasks;

  const TaskPageContent({
    Key? key,
    required this.task,
    required this.tasks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleField(context, task, tasks),
        const SizedBox(height: 15),
        _tagsPanel(context, task, tasks),
        const SizedBox(height: 15),
        _actionsPanel(context, task, tasks, height, width),
        const SizedBox(height: 15),
        _subtasksPanel(context, task, width, height)
      ],
    );
  }

  Widget _title(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _titleField(BuildContext context, Task task, List<Task> tasks) {
    TextEditingController titleController = TextEditingController();
    titleController.text = task.title;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FocusScope(
          child: Focus(
            onFocusChange: (focus) {
              if (focus == false) {
                task.title = titleController.text;
                final cubit = context.read<TaskBloc>();
                cubit.add(UpdateTask(task.id!, task, tasks));
              }
            },
            child: TextField(
              readOnly: !(user!.id == task.userID),
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
          ),
        ),
        const SizedBox(height: 15),
        const Text('Дата завершения:'),
        const SizedBox(height: 5),
        Text(DateFormat.yMMMd('ru').format(task.completeDate))
      ],
    );
  }

  Widget _descriptionField(BuildContext context, Task task) {
    TextEditingController descriptionController = TextEditingController();
    descriptionController.text = task.description;
    return Material(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: FocusScope(
        child: Focus(
          onFocusChange: (focus) {
            if (focus == false) {
              task.description = descriptionController.text;
              final cubit = context.read<TaskBloc>();
              cubit.add(UpdateTask(task.id!, task, []));
            }
          },
          child: TextField(
            readOnly: !(user!.id == task.userID),
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
        ),
      ),
    );
  }

  Widget _tagsPanel(BuildContext context, Task task, List<Task> tasks) {
    return BlocBuilder<TagBloc, TagState>(
      bloc: context.read<TagBloc>()..add(GetTagsListOfUser(user!.id!)),
      builder: (context, state) {
        if (state is TagListLoaded) {
          return SelectTagPanel(
            task: task,
            context: context,
            userTags: state.tagModel,
            tasks: tasks,
          );
        } else if (state is TagLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return SelectTagPanel(
            task: task,
            context: context,
            userTags: [],
            tasks: tasks,
          );
        }
      },
    );
  }

  Widget _actionsPanel(BuildContext context, Task task, List<Task> tasks,
      double height, double width) {
    if (user!.id == task.userID) {
      return Row(
        children: [
          _action(
            Icons.share,
            context,
            task,
            tasks,
            _shareTask,
            'Поделиться\nзадачей',
            width,
            height,
          ),
          const SizedBox(width: 15),
          _action(
            Icons.list_alt_rounded,
            context,
            task,
            tasks,
            _selectLists,
            'Списки',
            width,
            height,
          ),
          const SizedBox(width: 15),
          _action(
            Icons.person,
            context,
            task,
            tasks,
            _showUsers,
            'Пользователи',
            width,
            height,
          ),
        ],
      );
    }
    return Container();
  }

  Widget _action(
    IconData icon,
    BuildContext context,
    Task task,
    List<Task> tasks,
    Function(BuildContext, Task, List<Task> tasks, double, double) onTap,
    String text,
    double width,
    double height,
  ) {
    return InkWell(
      onTap: () => onTap(context, task, tasks, height, width),
      child: Material(
        elevation: 8.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        child: Container(
          width: width * 0.27,
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

  ///////////////////*********************SUBTASK********************/////////////////

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
        _descriptionField(context, task)
      ],
    );
  }

  Widget _subTaskListBuilder(
    BuildContext context,
    Task task,
    double width,
    double height,
  ) {
    return BlocConsumer<SubtaskBloc, SubtaskState>(
      bloc: context.read<SubtaskBloc>(),
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
        return _subtaskList(context, task.subTasks, task);
      },
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
          final cubit = context.read<SubtaskBloc>();
          cubit.add(CreateSubtask(controller.text, task));
          controller.clear();
        },
      ),
    );
  }

  void deleteSubtask(
    BuildContext context,
    SubTask subTask,
    List<SubTask> subtasks,
    Task task,
  ) {
    Widget okButton = TextButton(
      onPressed: () {
        final cubit = context.read<SubtaskBloc>();
        cubit.add(DeleteSubtask(subTask.id!, subtasks));
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
    Task task,
  ) {
    return InkWell(
      onLongPress: () => deleteSubtask(context, subTask, subtasks, task),
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
            final cubit = context.read<SubtaskBloc>();
            cubit.add(UpdateSubtask(subTask, task, subTask.id!, subtasks));
          },
        ),
      ),
    );
  }

  Widget _subtaskList(BuildContext context, List<SubTask> subtasks, Task task) {
    return Column(
      children: [
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) =>
              _subTask(context, subtasks[index], subtasks, task),
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemCount: subtasks.length,
        ),
        _subtaskAddField(context, task, subtasks),
      ],
    );
  }

  ///////////////////*********************SUBTASK********************/////////////////

  void _selectLists(
    BuildContext context,
    Task task,
    List<Task> tasks,
    double height,
    double width,
  ) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) => SelectListDialog(
        context: context,
        task: task,
        tasks: tasks,
        height: height,
        width: width,
      ),
    );
  }

  _shareTask(BuildContext context, Task task, List<Task> tasks, double height,
      double width) {
    showDialog<void>(
      context: context,
      builder: (BuildContext _) => ShareTaskDialog(
        context: context,
        task: task,
        height: height,
        width: width,
      ),
    );
  }

  _showUsers(
      BuildContext context, Task task, List<Task> tasks, double width, height) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        final cubit = context.read<UserBloc>();
        return BlocConsumer<UserBloc, UserState>(
          bloc: cubit..add(GetUsersByTaskId(taskId: task.id!)),
          listener: (context, state) {
            if (state is UserError) {
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
          builder: (_, state) {
            if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserListLoaded) {
              return UserInTask(task: task, users: state.users);
            }
            return UserInTask(task: task, users: []);
          },
        );
      },
    );
  }
}

// TODO: НЕ НРАВИТСЯ, ПЕРЕДЕЛАТЬ, КОДЕР ДЕБИЛ
