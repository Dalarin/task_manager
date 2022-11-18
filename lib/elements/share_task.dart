import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/invite_bloc/invite_bloc.dart';
import '../models/taskInvite.dart';
import '../models/task.dart';
import '../providers/constants.dart';

class ShareTaskDialog extends StatelessWidget {
  final BuildContext context;
  final Task task;
  final double height;
  final double width;

  const ShareTaskDialog({
    Key? key,
    required this.context,
    required this.task,
    required this.height,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InviteBloc, InviteState>(
      bloc: this.context.read<InviteBloc>()
        ..add(GetInvitesByTask(taskId: task.id!)),
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
      builder: (consumerState, inviteState) {
        if (inviteState is InviteLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (inviteState is InviteTaskLoaded) {
          return _shareTaskAlertDialogContent(
            this.context,
            task,
            height,
            width,
            inviteState.invites,
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _shareTaskTextField(
      BuildContext blocContext, Task task, List<TaskInvite> invites) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        filled: false,
        hintText: 'Введите email пользователя',
        hintStyle: TextStyle(fontSize: 10),
      ),
      autocorrect: false,
      onSubmitted: (String text) {
        final cubit = blocContext.read<InviteBloc>();
        cubit.add(CreateTaskInvite(
            email: text, task: task, invites: invites, invitedBy: user!));
        Navigator.pop(context);
      },
    );
  }

  Widget _invite(
    BuildContext blocContext,
    TaskInvite invite,
    List<TaskInvite> invites,
  ) {
    return ChoiceChip(
      label: Text(invite.user!.email),
      labelStyle: const TextStyle(color: Colors.white),
      avatar: const Icon(
        Icons.cancel_outlined,
        color: Colors.white,
      ),
      selected: true,
      onSelected: (bool value) {
        final cubit = blocContext.read<InviteBloc>();
        cubit.add(DeleteTaskInvite(id: invite.id!, invites: invites));
        Navigator.pop(context);
      },
      selectedColor: Theme.of(context).primaryColor,
    );
  }

  Widget _sharesTaskList(
    BuildContext context,
    Task task,
    double height,
    List<TaskInvite> invites,
  ) {
    List<Widget> invitesChip =
        invites.map((e) => _invite(context, e, invites)).toList();
    invitesChip = invitesChip.isEmpty
        ? [const Center(child: Text('Отсутствуют созданные приглашения'))]
        : invitesChip;
    return Column(
      children: [
        SizedBox(
          height: height * 0.42,
          child: ListView(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              Wrap(
                spacing: 10,
                children: invitesChip,
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _shareTaskAlertDialogContent(
    BuildContext blocContext,
    Task task,
    double height,
    double width,
    List<TaskInvite> invites,
  ) {
    return AlertDialog(
      title: const Text('Приглашения'),
      content: StatefulBuilder(
        builder: (context, stateSetter) {
          return SingleChildScrollView(
            child: SizedBox(
              height: height * 0.5,
              width: width * 0.75,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _sharesTaskList(blocContext, task, height, invites),
                  _shareTaskTextField(blocContext, task, invites)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
