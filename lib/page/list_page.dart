import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/bloc/list_bloc/list_bloc.dart';
import 'package:task_manager/bloc/user_bloc/user_bloc.dart';
import 'package:task_manager/providers/constants.dart';
import 'package:task_manager/repository/invite_repository.dart';
import 'package:task_manager/repository/task_repository.dart';
import 'package:task_manager/repository/user_repository.dart';

import '../bloc/invite_bloc/invite_bloc.dart';
import '../bloc/task_bloc/task_bloc.dart';
import '../elements/share_list.dart';
import '../elements/task_list.dart';
import '../elements/users_in_list.dart';
import '../models/list.dart';

class ListPage extends StatelessWidget {
  final ListModel list;
  final List<ListModel> lists;

  const ListPage({Key? key, required this.list, required this.lists})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Страница списка
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(UserRepository()),
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
              appBar: _appBar(
                context,
                list,
                lists,
                MediaQuery.of(context).size.height,
                MediaQuery.of(context).size.width,
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  child: _listOfTasks(
                    context,
                    MediaQuery.of(context).size.height,
                    MediaQuery.of(context).size.width,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _listOfTasks(BuildContext context, double height, double width) {
    return BlocProvider<TaskBloc>(
      create: (context) => TaskBloc(TaskRepository()),
      child: Builder(
        builder: (context) {
          return BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              return TaskList(
                tasks: list.tasks,
                width: width,
                height: height,
                finalHeight: 0.4,
              );
            },
          );
        },
      ),
    );
  }

  void _deleteListDialog(BuildContext context) {
    Widget okButton = TextButton(
      onPressed: () {
        final cubit = context.read<ListBloc>();
        cubit.add(DeleteList(listModel: list, list: lists));
        Navigator.pop(context);
        Future.delayed(
          const Duration(milliseconds: 500),
          () => Navigator.pop(context),
        );
      },
      child: const Text('Да'),
    );
    AlertDialog alert = AlertDialog(
      title: const Text('Удаление списка'),
      content: Text.rich(
        TextSpan(
          text: 'Вы уверены, что хотите удалить список ',
          children: [
            TextSpan(
              text: list.title,
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

  _showUsers(BuildContext context, ListModel listModel, double width, height) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        final cubit = context.read<UserBloc>();
        return BlocConsumer<UserBloc, UserState>(
          bloc: cubit..add(GetUsersByListId(listId: list.id!)),
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
              return UserInList(listModel: listModel, users: state.users);
            }
            return UserInList(listModel: listModel, users: []);
          },
        );
      },
    );
  }

  _shareList(
    BuildContext context,
    ListModel listModel,
    double height,
    double width,
  ) {
    showDialog<void>(
      context: context,
      builder: (BuildContext _) {
        final cubit = context.read<InviteBloc>();
        return BlocConsumer<InviteBloc, InviteState>(
          bloc: cubit..add(GetInvitesByList(listId: list.id!)),
          listener: (context, state) {
            if (state is InviteError) {
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
            if (state is InviteLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is InviteListLoaded) {
              //TODO: С КОНТЕКСТОМ ИДЕЯ ХУЙНЯ, ПЕРЕДЕЛАТЬ
              return ShareListDialog(
                context: context,
                listModel: list,
                listInvite: state.invites,
                height: height,
                width: width,
              );
            }
            return ShareListDialog(
              context: context,
              listModel: list,
              listInvite: [],
              height: height,
              width: width,
            );
          },
        );
      },
    );
  }

  void _handleClick(
    BuildContext context,
    ListModel listModel,
    double height,
    double width,
    String value,
  ) {
    if (value == 'Удалить') {
      _deleteListDialog(context);
    } else if (value == 'Приглашения') {
      _shareList(context, listModel, height, width);
    } else if (value == 'Прикрепленные пользователи') {
      _showUsers(context, listModel, width, height);
    }
  }

  Widget _appBarActions(BuildContext context, ListModel listModel, double height, double width) {
    if (listModel.userId == user!.id!) {
      return   PopupMenuButton(
        itemBuilder: (_) {
          return {'Удалить', 'Приглашения', 'Прикрепленные пользователи'}
              .map((choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(choice),
            );
          }).toList();
        },
        onSelected: (value) => _handleClick(
          context,
          listModel,
          height,
          width,
          value,
        ),
      );

    }
    return Container();
  }

  AppBar _appBar(
    BuildContext context,
    ListModel listModel,
    List<ListModel> list,
    double height,
    double width,
  ) {
    TextEditingController titleController = TextEditingController();
    titleController.text = listModel.title;
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      actions: [_appBarActions(context, listModel, height, width)],
      iconTheme: const IconThemeData(color: Colors.black),
      title: FocusScope(
        child: Focus(
          onFocusChange: (bool focus) {
            listModel.title = titleController.text;
            final bloc = context.read<ListBloc>();
            bloc.add(UpdateList(list: listModel, lists: lists));
          },
          child: TextField(
            readOnly: !(user!.id! == listModel.userId),
            controller: titleController,
            decoration: const InputDecoration(
              filled: false,
              border: InputBorder.none,
            ),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
