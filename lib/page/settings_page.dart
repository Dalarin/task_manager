import 'package:flutter/material.dart';
import 'package:task_manager/page/tags_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _title('Настройки'),
              const SizedBox(height: 15),
              _settingsPanel(
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

  Widget _showTags(BuildContext context, double width, double height) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) {
              return TagsPage();
            },
          ),
        );
      },
      contentPadding: EdgeInsets.zero,
      title: const Text('Категории'),
      trailing: const Icon(Icons.keyboard_arrow_right_sharp),
    );
  }

  Widget _settingsPanel(BuildContext context, double width, double height) {
    return Column(
      children: [
        _showTags(context, width, height),
      ],
    );
  }

  Widget _title(String text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    );
  }
}
