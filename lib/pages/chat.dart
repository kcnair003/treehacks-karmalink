import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth.dart';
import '../blocs/theme/theme.dart';
import '../themes.dart';
import '../ui/auth_view.dart';
import '../ui/chat_list_view.dart';
import 'package:provider/provider.dart';

import '../blocs/my_bloc_observer.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../ui/chat_directory_view.dart';
import '../ui/ui_helper.dart';
import '../locator.dart';

class Chat extends StatelessWidget {
  Chat({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          RaisedButton(
            onPressed: () => FirestoreService().addGroup(),
            child: Text('+'),
          ),
          ThemeSwitch(),
        ],
      ),
      body: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * .2,
            child: ChatDirectoryView(),
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

class ThemeSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Switch(
      value: context.watch<ThemeCubit>().state == darkTheme,
      onChanged: (_) => context.read<ThemeCubit>().toggle(),
    );
  }
}
