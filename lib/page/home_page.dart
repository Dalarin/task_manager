import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/elements/list_of_lists_element.dart';
import 'package:task_manager/providers/constants.dart';
import 'package:task_manager/models/list.dart';
import 'package:task_manager/repository/task_repository.dart';

import '../bloc/list_bloc/list_bloc.dart';
import '../bloc/task_bloc/task_bloc.dart';
import '../elements/loading_element.dart';
import '../elements/task_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      extendBody: true,
      body: HomePageContent(),
    );
  }
}

class HomePageContent extends StatelessWidget {
  const HomePageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _body(context);
  }

  Widget _body(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _helloWidget(),
              const SizedBox(height: 15),
              _listHeader(text: 'Ваши списки'),
              const SizedBox(height: 15),
              const ListOfLists(),
              const SizedBox(height: 15),
              _listHeader(text: 'Список задач'),
              const SizedBox(height: 15),
              _listOfTasks(
                context,
                MediaQuery.of(context).size.height,
                MediaQuery.of(context).size.width,
              )
            ],
          ),
        ),
      ),
    );
  }
  

  Widget _listOfTasks(BuildContext context, double height, double width) {
    return BlocProvider<TaskBloc>(
      create: (context) =>
          TaskBloc(TaskRepository())..add(GetTaskList(user!.id!)),
      child: Builder(
        builder: (context) {
          return BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              if (state is TaskLoading) {
                return LoadingElement(
                  height: height * 0.1,
                  width: width * 0.45,
                  scrollDirection: Axis.vertical,
                  boxSize: height * 0.4,
                );
              } else if (state is TaskError) {
                return Text(state.message);
              } else if (state is TaskListLoaded) {
                return TaskList(
                  tasks: state.list,
                  width: width,
                  height: height,
                  finalHeight: 0.4,
                );
              } else {
                return TaskList(
                  tasks: const [],
                  width: width,
                  height: height,
                  finalHeight: 0.4,
                );
              }
            },
          );
        }
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

  @override
  void initState() {
    titleController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
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

// TODO: виджеты перестраиваются, переделать
  Widget _createButton(BuildContext context) {
    return InkWell(
      onTap: () {
        final cubit = context.read<ListBloc>();
        cubit.add(CreateList(user!.id!, titleController.text, DateTime.now(),
            widget.list as List<ListModel>));
        Navigator.of(context).pop();
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.07,
        width: MediaQuery.of(context).size.width,
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
