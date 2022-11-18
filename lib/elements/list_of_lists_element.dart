import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/repository/list_repository.dart';
import '../models/list.dart';
import '../bloc/list_bloc/list_bloc.dart';
import '../page/home_page.dart';
import '../providers/constants.dart';
import 'list_element.dart';
import 'loading_element.dart';

class ListOfLists extends StatelessWidget {
  const ListOfLists({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ListBloc>(
      create: (_) => ListBloc(ListRepository())..add(LoadLists(user!.id!)),
      child: BlocBuilder<ListBloc, ListState>(
        builder: (context, state) {
          if (state is ListLoading) {
            return LoadingElement(
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width * 0.45,
              scrollDirection: Axis.horizontal,
              boxSize: MediaQuery.of(context).size.height * 0.4,
            );
          } else if (state is ListError) {
            return Text(state.message);
          } else if (state is ListLoaded) {
            return _listListView(context, state.list);
          } else {
            return _listListView(context, []);
          }
        },
      ),
    );
  }

  Widget _listListView(BuildContext context, List<ListModel> list) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ListView.separated(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) =>
                  ListElement(list: list[index], lists: list),
              separatorBuilder: (context, index) => const SizedBox(width: 15),
              itemCount: list.length,
            ),
            const SizedBox(width: 15),
            _createListButton(context, list)
          ],
        ),
      ),
    );
  }

  Widget _createListButton(BuildContext context, List list) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          context: context,
          builder: (ctx) => CreateListBottomMenu(context: context, list: list),
        );
      },
      child: Material(
        borderRadius: BorderRadius.circular(20),
        elevation: 8.0,
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 0.45,
          height: MediaQuery.of(context).size.height * 0.25,
          child: const Text(
            'Создать новый список',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
