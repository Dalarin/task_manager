import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/models/list.dart';
import 'package:task_manager/models/listInvite.dart';

import '../bloc/invite_bloc/invite_bloc.dart';
import '../providers/constants.dart';

class ShareListDialog extends StatelessWidget {
  final BuildContext context;
  final ListModel listModel;
  final List<ListInvite> listInvite;
  final double height;
  final double width;

  const ShareListDialog({
    Key? key,
    required this.context,
    required this.listModel,
    required this.listInvite,
    required this.height,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Приглашения'),
      content: StatefulBuilder(
        builder: (_, stateSetter) {
          return SingleChildScrollView(
            child: SizedBox(
              height: height * 0.5,
              width: width * 0.75,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _sharesListModelList(this.context, listModel, height, listInvite),
                  _shareListTextField(this.context, listModel, listInvite)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _shareListTextField(
    BuildContext context,
    ListModel listModel,
    List<ListInvite> invites,
  ) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        filled: false,
        hintText: 'Введите email пользователя',
        hintStyle: TextStyle(fontSize: 10),
      ),
      autocorrect: false,
      onSubmitted: (String text) {
        final cubit = context.read<InviteBloc>();
        cubit.add(CreateListInvite(
          email: text,
          listModel: listModel,
          invites: invites,
          invitedBy: user!,
        ));
        Navigator.pop(context);
      },
    );
  }

  Widget _invite(
    BuildContext context,
    ListInvite invite,
    List<ListInvite> invites,
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
        final cubit = context.read<InviteBloc>();
        cubit.add(DeleteListInvite(id: invite.id!, invites: invites));
        Navigator.pop(context);
      },
      selectedColor: Theme.of(context).primaryColor,
    );
  }

  Widget _sharesListModelList(
    BuildContext context,
    ListModel listModel,
    double height,
    List<ListInvite> invites,
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

}
