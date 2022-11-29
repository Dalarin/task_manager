import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/bloc/invite_bloc/invite_bloc.dart';
import 'package:task_manager/models/listInvite.dart';
import 'package:task_manager/models/taskInvite.dart';
import 'package:task_manager/repository/invite_repository.dart';

import '../providers/constants.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _title('Уведомления'),
                const SizedBox(height: 15),
                _notificationTaskBuilder(context),
                const SizedBox(height: 15),
                const Text(
                  'Списки',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 15),
                _notificationListBuilder(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dismissibleBackground(Color color) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: color,
      ),
    );
  }

  Widget _taskInvite(
    BuildContext context,
    TaskInvite invite,
    List<TaskInvite> taskInvites,
  ) {
    return Dismissible(
      background: _dismissibleBackground(Colors.green),
      secondaryBackground: _dismissibleBackground(Colors.red),
      onDismissed: (DismissDirection direction) {
        final bloc = context.read<InviteBloc>();
        invite.user = user!;
        if (direction == DismissDirection.startToEnd) {
          bloc.add(AcceptTaskInvite(
            taskInvite: invite,
            taskInviteList: taskInvites,
          ));
        } else {
          bloc.add(DeleteTaskInvite(id: invite.id!, invites: taskInvites));
        }
      },
      key: ValueKey<int>(invite.id!),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.1,
        child: Material(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: Text.rich(
              TextSpan(
                text: 'Пользователь ',
                children: [
                  TextSpan(
                    text: invite.invitedBy.fio,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(
                      text: ' пригласил вас присоединиться к задаче '),
                  TextSpan(
                    text: invite.task.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _listInvite(
    BuildContext context,
    ListInvite invite,
    List<ListInvite> listInvites,
  ) {
    return Dismissible(
      background: _dismissibleBackground(Colors.green),
      secondaryBackground: _dismissibleBackground(Colors.red),
      onDismissed: (DismissDirection direction) {
        final bloc = context.read<InviteBloc>();
        invite.user = user!;
        if (direction == DismissDirection.startToEnd) {
          bloc.add(AcceptListInvite(
            listInvite: invite,
            listInviteList: listInvites,
          ));
        } else {
          bloc.add(DeleteListInvite(id: invite.id!, invites: listInvites));
        }
      },
      key: ValueKey<int>(invite.id!),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.1,
        child: Material(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: Text.rich(
              TextSpan(
                text: 'Пользователь ',
                children: [
                  TextSpan(
                    text: invite.invitedBy.fio,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(
                      text: ' пригласил вас присоединиться к списку '),
                  TextSpan(
                    text: invite.listModel.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _notificationTaskList(
    BuildContext context,
    List<TaskInvite> listInvites,
  ) {
    if (listInvites.isNotEmpty) {
      return ListView.builder(
        itemCount: listInvites.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return _taskInvite(context, listInvites[index], listInvites);
        },
      );
    }
    return Material(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width,
        child: const Text('Отсутствуют новые уведомления для задач'),
      ),
    );
  }

  Widget _notificationListList(
    BuildContext context,
    List<ListInvite> listInvites,
  ) {
    if (listInvites.isNotEmpty) {
      return ListView.builder(
        itemCount: listInvites.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return _listInvite(context, listInvites[index], listInvites);
        },
      );
    }
    return Material(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width,
        child: const Text('Отсутствуют новые уведомления для списков'),
      ),
    );
  }

  Widget _notificationTaskBuilder(BuildContext context) {
    return BlocProvider<InviteBloc>(
      create: (context) => InviteBloc(InviteRepository())
        ..add(GetTaskInvitesByUser(userId: user!.id!)),
      child: BlocBuilder<InviteBloc, InviteState>(
        builder: (context, state) {
          print('TASK STATE $state');
          if (state is InviteTaskLoaded) {
            return _notificationTaskList(context, state.invites);
          }
          return Container();
        },
      ),
    );
  }

  Widget _notificationListBuilder(BuildContext context) {
    return BlocProvider<InviteBloc>(
      create: (context) => InviteBloc(InviteRepository())
        ..add(GetListInvitesByUser(userId: user!.id!)),
      child: BlocBuilder<InviteBloc, InviteState>(
        builder: (context, state) {
          print('LIST STATE $state');
          if (state is InviteListLoaded) {
            return _notificationListList(context, state.invites);
          }
          return Container();
        },
      ),
    );
  }

  Widget _title(String text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    );
  }
}
