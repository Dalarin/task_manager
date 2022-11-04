import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/list.dart' as model;
import '../bloc/list_bloc/list_bloc.dart';
import '../page/home_page.dart';
import '../providers/constants.dart';
import '../repository/list_repository.dart';
import 'list_element.dart';
import 'loading_element.dart';

class ListOfLists extends StatelessWidget {
  const ListOfLists({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BlocProvider<ListBloc>(
      create: (context) =>
          ListBloc(ListRepository())..add(LoadLists(user!.id!)),
      child: BlocListener<ListBloc, ListState>(
        child: BlocBuilder<ListBloc, ListState>(
          builder: (ctx, state) {
            if (state is ListLoading) {
              return LoadingElement(
                height: height * 0.25,
                width: width * 0.45,
                scrollDirection: Axis.horizontal,
                boxSize: height * 0.4,
              );
            } else if (state is ListError) {
              return Text(state.message);
            } else if (state is ListLoaded) {
              return _listListView(ctx, state.list);
            } else {
              return _listListView(ctx, []);
            }
          },
        ),
        listener: (context, state) {
        },
      ),
    );
  }

  Widget _listListView(BuildContext context, List<model.ListModel> list) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ListView.separated(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) => ListElement(list: list[index]),
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

  Widget _createListButton(BuildContext ctx, List list) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          context: ctx,
          builder: (context) => CreateListBottomMenu(context: ctx, list: list),
        );
      },
      child: Material(
        borderRadius: BorderRadius.circular(20),
        elevation: 8.0,
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(ctx).size.width * 0.45,
          height: MediaQuery.of(ctx).size.height * 0.25,
          child: const Text(
            'Создать новый список',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
