
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/bloc/tag_bloc/tag_bloc.dart';
import 'package:task_manager/providers/constants.dart';
import 'package:task_manager/repository/tag_repository.dart';
import 'package:task_manager/repository/task_repository.dart';

import '../bloc/task_bloc/task_bloc.dart';
import '../models/tag.dart';

class CreateTaskPage extends StatelessWidget {
  const CreateTaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskBloc>(
      create: (context) => TaskBloc(TaskRepository()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            appBar: _appBar(context),
            body: SafeArea(
              child: BlocListener<TaskBloc, TaskState>(
                bloc: context.read<TaskBloc>(),
                listener: (context, state) {
                  if (state is TaskError) {
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
                child: CreateTaskPageContent(taskContext: context),
              ),
            ),
          );
        }
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      elevation: 0.0,
      leading: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.arrow_back_ios_new_rounded),
      ),
      title: const Text(
        'Создание новой задачи',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class CreateTaskPageContent extends StatefulWidget {
  final BuildContext taskContext;

  const CreateTaskPageContent({
    Key? key,
    required this.taskContext,
  }) : super(key: key);

  @override
  State<CreateTaskPageContent> createState() => _CreateTaskPageContentState();
}

class _CreateTaskPageContentState extends State<CreateTaskPageContent> {
  late TextEditingController titleController;
  late TextEditingController dateController;
  late TextEditingController descriptionController;
  DateTime _selectedDate = DateTime.now();
  List<Tag> selectedTags = [];

  @override
  void initState() {
    titleController = TextEditingController();
    dateController = TextEditingController();
    descriptionController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: height * 0.0003),
              _topContainer(),
              _bottomContainer(width, height),
            ],
          ),
        )
      ],
    );
  }

  // TODO: ПЕРЕДЕЛАТЬ СТРУКТУРУ
  Widget _bottomContainer(double width, double height) {
    return Container(
      width: width,
      height: height * 0.65,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _textField(
                controller: descriptionController,
                label: 'Описание',
                context: context,
                textColor: Colors.black,
                maxLines: 6,
              ),
              SizedBox(height: height * 0.03),
              const Text(
                'Категории',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: height * 0.03),
              TagList(selectedTags: selectedTags),
            ],
          ),
          Column(
            children: [
              _createTaskButton(context, height, width),
            ],
          )
        ],
      ),
    );
  }

  _selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
      _selectedDate = picked;
      dateController.text = DateFormat.yMMMd('ru').format(_selectedDate);
    }
  }

  Widget _topContainer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        children: [
          _textField(
            controller: titleController,
            label: 'Название',
            context: context,
            textColor: Colors.white,
          ),
          const SizedBox(height: 15),
          _textField(
            controller: dateController,
            label: 'Дата завершения',
            context: context,
            textColor: Colors.white,
            onTap: _selectDate,
          )
        ],
      ),
    );
  }

  Widget _createTaskButton(BuildContext context, double height, double width) {
    return InkWell(
      onTap: () {
        BlocProvider.of<TaskBloc>(context).add(
          CreateTask(
            user!.id!,
            titleController.text,
            descriptionController.text,
            DateTime.now(),
            _selectedDate,
            selectedTags,
            [],
          ),
        );
        Navigator.of(context).pop();
      },
      child: Container(
        height: height * 0.08,
        width: width,
        alignment: Alignment.center,
        decoration:  BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: const Text(
          'Создать задание',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _textField(
      {required TextEditingController controller,
      required String label,
      required BuildContext context,
      required Color textColor,
      int? maxLines,
      Function()? onTap}) {
    return TextField(
      onTap: onTap,
      controller: controller,
      style: TextStyle(color: textColor),
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
        filled: false,
        label: Text(label),
        labelStyle: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: textColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: textColor),
        ),
        border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
      ),
    );
  }
}

class TagList extends StatelessWidget {
  final List<Tag> selectedTags;

  const TagList({Key? key, required this.selectedTags}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TagBloc>(
      create: (context) =>
          TagBloc(TagRepository())..add(GetTagsListOfUser(user!.id!)),
      child: BlocListener<TagBloc, TagState>(
        listener: (context, state) {},
        child: BlocBuilder<TagBloc, TagState>(
          builder: (context, state) {
            if (state is TagLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TagListLoaded) {
              return TagListContent(
                tags: state.tagModel,
                selectedTags: selectedTags,
              );
            } else {
              return TagListContent(
                tags: const [],
                selectedTags: selectedTags,
              );
            }
          },
        ),
      ),
    );
  }
}

class TagListContent extends StatefulWidget {
  final List<Tag> tags;
  final List<Tag> selectedTags;

  const TagListContent({
    Key? key,
    required this.tags,
    required this.selectedTags,
  }) : super(key: key);

  @override
  State<TagListContent> createState() => _TagListContentState();
}

class _TagListContentState extends State<TagListContent> {
  @override
  Widget build(BuildContext context) {
    return _tagsList(widget.tags);
  }

  Widget _tagElement(Tag tag) {
    bool isSelected =
        widget.selectedTags.where((element) => element.id == tag.id).isNotEmpty;
    return ChoiceChip(
      avatar: isSelected ? const Icon(Icons.cancel) : null,
      disabledColor: Color(int.parse(tag.color)),
      selectedColor: Color(int.parse(tag.color)),
      backgroundColor: Color(int.parse(tag.color)),
      label: Text(tag.title, style: const TextStyle(color: Colors.white)),
      selected: isSelected,
      onSelected: (bool value) {
        setState(() {
          !isSelected
              ? widget.selectedTags.add(tag)
              : widget.selectedTags.remove(tag);
        });
      },
    );
  }

  Widget _tagsList(List<Tag> tags) {
    if (tags.isNotEmpty) {
      return Wrap(
        spacing: 10,
        children: tags.map((e) => _tagElement(e)).toList(),
      );
    } else {
      return Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5.0,
        child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width,
          child: const Text('Отсутствуют созданные категории'),
        ),
      );
    }
  }
}
