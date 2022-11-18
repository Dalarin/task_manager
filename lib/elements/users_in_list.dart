import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/models/list.dart';

import '../bloc/user_bloc/user_bloc.dart';
import '../models/user.dart';

///Список пользователей в задаче
class UserInList extends StatelessWidget {
  final ListModel listModel;
  final List<User> users;

  const UserInList({Key? key, required this.listModel, required this.users})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: const Text('Пользователи, прикрепленные к задаче'),
      content: StatefulBuilder(
        builder: (_, stateSetter) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.75,
            child: _showUsersList(
              context,
              listModel,
              MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height,
              users,
            ),
          );
        },
      ),
    );
  }

  Widget _userWrap(List<Widget> userChip, double height) {
    if (userChip.isNotEmpty) {
      return Wrap(
        runSpacing: height * 0.015,
        children: userChip,
      );
    }
    return const Center(child: Text('Отсутствуют прикрепленные пользователи'));
  }

  Widget _showUsersList(
    BuildContext context,
    ListModel listModel,
    double width,
    double height,
    List<User> users,
  ) {
    List<Widget> userChip = users
        .map((e) => _user(context, e, users, listModel, width, height))
        .toList();
    return Column(
      children: [
        SizedBox(
          height: height * 0.5,
          child: ListView(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [_userWrap(userChip, height)],
          ),
        ),
      ],
    );
  }

  Widget _user(BuildContext context, User user, List<User> users,
      ListModel listModel, double width, double height) {
    var fio = user.fio.split(' ');
    String label = fio[0][0] + fio[1][0];
    return RawChip(
      tooltip: user.email,
      showCheckmark: false,
      onDeleted: () => _confirmDeletingUserFromTask(
        context,
        user,
        users,
        listModel,
      ),
      deleteIcon: const Icon(
        Icons.cancel_outlined,
        color: Colors.white,
      ),
      label: Container(
        alignment: Alignment.center,
        height: height * 0.035,
        child: Text(
          user.fio,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      avatar: CircleAvatar(
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            label,
            softWrap: true,
          ),
        ),
      ),
      selected: true,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      selectedColor: Theme.of(context).primaryColor,
      onSelected: (bool value) {},
    );
  }

  _confirmDeletingUserFromTask(
    BuildContext context,
    User user,
    List<User> users,
    ListModel listModel,
  ) {
    const style = TextStyle(height: 1.2);
    showDialog<void>(
      context: context,
      builder: (BuildContext _) {
        return AlertDialog(
          title: const Text('Удаление пользователя из задачи'),
          content: Text.rich(
            TextSpan(
              text: 'Вы уверены, что хотите удалить пользователя ',
              children: [
                TextSpan(
                  text: user.fio,
                  style: style.copyWith(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: ' из задачи ', style: style),
                TextSpan(
                  text: listModel.title,
                  style: style.copyWith(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Да'),
              onPressed: () {
                final cubit = context.read<UserBloc>();
                cubit.add(DeleteUserFromList(
                  listId: listModel.id!,
                  userId: user.id!,
                ));
                Navigator.of(_).pop();
                Navigator.of(context).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }
}
