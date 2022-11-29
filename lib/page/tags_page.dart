import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:task_manager/providers/constants.dart';
import 'package:task_manager/repository/tag_repository.dart';

import '../bloc/tag_bloc/tag_bloc.dart';
import '../models/tag.dart';

class TagsPage extends StatelessWidget {
  const TagsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TagBloc>(
      create: (context) => TagBloc(TagRepository()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Категории',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              iconTheme: const IconThemeData(color: Colors.black),
            ),
            body: BlocListener<TagBloc, TagState>(
              listener: (context, state) {
                if (state is TagError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message!),
                    ),
                  );
                }
              },
              child: SafeArea(
                child: _tagsListBuilder(context),
              ),
            ),
          );
        },
      ),
    );
  }

  void _createTagDialog(
    BuildContext context,
    Tag? tag,
    List<Tag> tags,
    double width,
    double height,
  ) {
    showDialog<void>(
      context: context,
      builder: (BuildContext _) {
        return BlocProvider.value(
          value: context.read<TagBloc>(),
          child: CreateTagDialog(
            tag: tag,
            tags: tags,
            width: width,
            height: height,
          ),
        );
      },
    );
  }

  Widget _tagElement(BuildContext context, List<Tag> tags, Tag tag) {
    return ListTile(
      onTap: () {
        _createTagDialog(
          context,
          tag,
          tags,
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height,
        );
      },
      tileColor: Color(
        int.parse(tag.color),
      ),
      title: Text(
        tag.title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: const Icon(Icons.keyboard_arrow_right_outlined),
    );
  }

  Widget _createTagElement(BuildContext context, List<Tag> tags) {
    return ListTile(
      onTap: () {
        _createTagDialog(
          context,
          null,
          tags,
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height,
        );
      },
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.black),
      ),
      title: const Text('Создать новую категорию'),
    );
  }

  Widget _tagsList(BuildContext context, List<Tag> tags) {
    if (tags.isEmpty) {
      return const Center(
        child: Text('Отсутствуют созданные категории'),
      );
    }
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: tags.length,
          itemBuilder: (_, index) {
            return _tagElement(context, tags, tags[index]);
          },
        ),
        _createTagElement(context, tags)
      ],
    );
  }

  Widget _tagsListBuilder(BuildContext context) {
    return BlocBuilder<TagBloc, TagState>(
      bloc: context.read<TagBloc>()..add(GetTagsListOfUser(user!.id!)),
      builder: (context, state) {
        if (state is TagListLoaded) {
          return _tagsList(context, state.tagModel);
        } else if (state is TagLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Container();
      },
    );
  }
}

class CreateTagDialog extends StatefulWidget {
  final double width;
  final double height;
  final List<Tag> tags;
  final Tag? tag;

  const CreateTagDialog({
    Key? key,
    required this.width,
    required this.height,
    required this.tags,
    this.tag,
  }) : super(key: key);

  @override
  State<CreateTagDialog> createState() => _CreateTagDialogState();
}

class _CreateTagDialogState extends State<CreateTagDialog> {
  late TextEditingController titleController;
  late Color pickedColor;

  @override
  void initState() {
    titleController = TextEditingController();
    pickedColor = Colors.white;
    if (widget.tag != null) {
      pickedColor = Color(int.parse(widget.tag!.color));
      titleController.text = widget.tag!.title;
    }
    super.initState();
  }

  Widget _colorPicker(BuildContext context) {
    return BlockPicker(
      pickerColor: pickedColor,
      onColorChanged: (Color color) {
        pickedColor = color;
      },
    );
  }

  Widget _titleField(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        hintText: 'Название категории',
        filled: false,
      ),
      controller: titleController,
    );
  }

  Widget _alertDialogBody(BuildContext context) {
    return Column(
      children: [
        _titleField(context),
        const SizedBox(height: 15),
        _colorPicker(context)
      ],
    );
  }

  void _confirmDeleting(BuildContext context, Tag tag, List<Tag> tags) {
    showDialog<void>(
      context: context,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Удаление категории'),
          content: Text.rich(
            TextSpan(
              text: 'Вы уверены, что хотите удалить категорию ',
              children: [
                TextSpan(
                  text: tag.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Да'),
              onPressed: () {
                final bloc = context.read<TagBloc>();
                bloc.add(DeleteTag(tag.id!, tags));
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }

  Widget _deleteIcon(BuildContext context, Tag? tag, List<Tag> tags) {
    if (tag != null) {
      return InkWell(
        onTap: () {
          _confirmDeleting(context, tag, tags);
        },
        child: const Icon(Icons.delete),
      );
    }
    return Container();
  }

  Widget _confirmIcon(BuildContext context, Tag? tag, List<Tag> tags) {
    return InkWell(
      onTap: () {
        final bloc = context.read<TagBloc>();
        if (tag != null) {
          tag.title = titleController.text;
          tag.color = pickedColor.value.toString();
          bloc.add(UpdateTag(tag.id!, tag, widget.tags));
        } else {
          bloc.add(CreateTag(
            userId: user!.id!,
            title: titleController.text,
            color: pickedColor.value,
            tags: tags,
          ));
        }
        Navigator.of(context).pop();
      },
      child: Icon(tag != null ? Icons.check : Icons.add),
    );
  }

  Widget _alertDialogTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.tag != null ? 'Редактирование' : 'Создание категории'),
        _deleteIcon(context, widget.tag, widget.tags),
        _confirmIcon(context, widget.tag, widget.tags)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _alertDialogTitle(context),
      content: SizedBox(
        height: widget.height * 0.5,
        width: widget.width * 0.75,
        child: SingleChildScrollView(
          child: _alertDialogBody(context),
        ),
      ),
    );
  }
}
