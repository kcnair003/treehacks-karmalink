import 'package:flutter/material.dart';
import 'package:treehacks2021/blocs/blocs.dart';
import 'package:treehacks2021/services/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehacks2021/widgets/chat_directory.dart';
import 'package:treehacks2021/widgets/chat_list_view.dart';
import 'package:treehacks2021/widgets/theme_switch.dart';

import '../constants/Themes.dart';

class ChatView extends StatelessWidget {
  ChatView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversations'),
        actions: [
          ThemeSwitch(),
        ],
      ),
      body: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * .2,
            child: ChatDirectory(),
          ),
          VerticalDivider(
            width: 0,
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: ChatListView(),
                  ),
                  MyTextField(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: TextFormField()),
          SizedBox(width: 4),
          GestureDetector(
            onTap: () => print('send message not implemented yet...'),
            child: Icon(Icons.send),
          ),
          SizedBox(width: 8),
        ],
      ),
    );
  }
}
