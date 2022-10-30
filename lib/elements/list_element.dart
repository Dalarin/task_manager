import 'package:flutter/material.dart';
import 'package:task_manager/page/list_page.dart';
import '../models/list.dart';
import 'package:intl/intl.dart';

class ListElement extends StatelessWidget {
  final List list;
  late double width;
  late double height;

  ListElement({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ListPage(),
          ),
        );
      },
      child: Material(
        elevation: 5.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          height: height * 0.25,
          width: width * 0.45,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            color: Color(0xFF3B378E),
          ),
          child: Column(
            children: [
              _header(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Text(
                list.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
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
