import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/elements/list_of_lists_element.dart';
import 'package:task_manager/providers/constants.dart';
import 'package:task_manager/models/list.dart' as model;

import '../bloc/list_bloc/list_bloc.dart';
import '../elements/list_of_tasks_element.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: HomePageContent(context: context),
    );
  }

  AppBar _appBar(BuildContext context) {
    List<String> partsOfFio = user!.fio.split(' ');
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      actions: [
        CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(partsOfFio[1][0] + partsOfFio[0][0]),
        )
      ],
    );
  }
}

class HomePageContent extends StatelessWidget {
  final BuildContext context;

  const HomePageContent({Key? key, required this.context}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _body(context);
  }

  Widget _body(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _helloWidget(),
            _listHeader(text: 'Ваши списки'),
            const ListOfLists(),
            _listHeader(text: 'Список задач'),
            const ListOfTasks(),
          ],
        ),
      ),
    );
  }

  Widget _listHeader({required String text}) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 17,
      ),
    );
  }

  Widget _helloWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Привет, ',
            style: const TextStyle(
              fontSize: 20,
              fontFamily: 'Gotham',
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: user!.fio,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Gotham',
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Хорошего дня!',
          style: TextStyle(color: Colors.grey),
        )
      ],
    );
  }
}

class CreateListBottomMenu extends StatefulWidget {
  final BuildContext context;
  final List list;

  const CreateListBottomMenu(
      {Key? key, required this.context, required this.list})
      : super(key: key);

  @override
  State<CreateListBottomMenu> createState() => _CreateListBottomMenuState();
}

class _CreateListBottomMenuState extends State<CreateListBottomMenu> {
  late TextEditingController titleController;
  late double height;
  late double width;

  @override
  void initState() {
    titleController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: height * 0.3,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Создание списка',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            _textInput(
              controller: titleController,
              icon: const Icon(Icons.label),
              label: 'Название списка',
              isPassword: false,
            ),
            _createButton(widget.context)
          ],
        ),
      ),
    );
  }

  Widget _createButton(BuildContext context) {
    return InkWell(
      onTap: () {
        BlocProvider.of<ListBloc>(context).add(
          CreateList(user!.id!, titleController.text, DateTime.now(),
              widget.list as List<model.List>),
        );
        Navigator.of(context).pop();
      },
      child: Container(
        height: height * 0.07,
        width: width,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color(0xFF3B378E),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: const Text(
          'Создать список',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _textInput(
      {required TextEditingController controller,
      required Icon icon,
      required String label,
      required bool isPassword}) {
    return TextField(
      obscureText: isPassword,
      controller: controller,
      enableSuggestions: !isPassword,
      autocorrect: !isPassword,
      decoration: InputDecoration(
        hintText: label,
        prefixIcon: icon,
      ),
    );
  }
}
