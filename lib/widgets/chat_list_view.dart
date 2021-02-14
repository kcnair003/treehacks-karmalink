import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehacks2021/blocs/chat/chat.dart';
import 'package:treehacks2021/models/models.dart';
import 'package:treehacks2021/models/src/message.dart';
import 'package:treehacks2021/services/services.dart';
import 'package:provider/provider.dart';

import 'message_view.dart';

class ChatListView extends StatelessWidget {
  ChatListView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChatState state = context.watch<ChatCubit>().state;

    return ListView.builder(
      reverse: true,
      itemCount: state.messages.length,
      itemBuilder: (context, index) {
        return MessageView(
          index: index,
          message: state.messages[index],
        );
      },
    );
  }
}
