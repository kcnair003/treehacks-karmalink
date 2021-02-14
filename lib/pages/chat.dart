import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehacks2021/blocs/blocs.dart';
import 'package:treehacks2021/models/models.dart';
import 'package:treehacks2021/services/services.dart';
import 'package:treehacks2021/widgets/chat_directory.dart';
import 'package:treehacks2021/widgets/chat_list_view.dart';
import 'package:treehacks2021/widgets/theme_switch.dart';

class ChatView extends StatelessWidget {
  ChatView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatCubit(),
      child: Scaffold(
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
      ),
    );
  }
}

class MyTextField extends StatefulWidget {
  MyTextField({Key key}) : super(key: key);

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ChatState state = context.watch<ChatCubit>().state;
    User user = context.watch<AuthCubit>().state.user;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
              child: TextFormField(
            controller: _messageController,
          )),
          SizedBox(width: 4),
          GestureDetector(
            onTap: () {
              final firestore = FirestoreService();
              firestore.updateGroup(
                state.group.id,
                {'last_updated': FieldValue.serverTimestamp()},
              );
              firestore.addMessage(
                state.group.id,
                user.uid,
                user.displayName,
                _messageController.text,
              );
              _messageController.clear();
            },
            child: Icon(Icons.send),
          ),
          SizedBox(width: 8),
        ],
      ),
    );
  }
}
