import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/page/list_page.dart';
import '../bloc/list_bloc/list_bloc.dart';
import '../models/list.dart';
import 'package:intl/intl.dart';

class ListElement extends StatelessWidget {
  final ListModel list;
  final List<ListModel> lists;

  const ListElement({Key? key, required this.list, required this.lists})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) {
              return BlocProvider.value(
                value: context.read<ListBloc>(),
                child: ListPage(
                  list: list,
                  lists: lists,
                ),
              );
            },
          ),
        );
      },
      child: Material(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          height: MediaQuery.of(context).size.height * 0.25,
          width: MediaQuery.of(context).size.width * 0.45,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
            color: Theme.of(context).primaryColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _header(),
              Text(
                list.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _progressBar(
                context,
                MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _progressIndicator(
    BuildContext context,
    double width,
    double height,
    double value,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: width,
      height: height * 0.005,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        child: LinearProgressIndicator(
          value: value,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          backgroundColor: Colors.white10,
        ),
      ),
    );
  }

  double _value({double value = 0.0}) =>
      value.isNaN || value.isInfinite ? 0.0 : value;

  Widget _progressBar(BuildContext context, double width, double height) {
    double value = list.tasks.where((element) => element.isCompleted).length /
        list.tasks.length;
    value = _value(value: value);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Прогресс', style: TextStyle(color: Colors.white)),
            Text('${value * 100}%', style: const TextStyle(color: Colors.white))
          ],
        ),
        const SizedBox(height: 5),
        _progressIndicator(context, width, height, value)
      ],
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          DateFormat.yMMM('ru').format(list.completeBy),
          textAlign: TextAlign.end,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
