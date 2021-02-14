import 'package:flutter/material.dart';
import 'package:treehacks2021/models/src/message.dart';

class MessageView extends StatefulWidget {
  MessageView({Key key, this.index, this.message}) : super(key: key);

  final int index;
  final Message message;

  @override
  _MessageViewState createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  @override
  void initState() {
    super.initState();
    // if (widget.index % 20 == 0) {
    //   context.read<PaginationCubit<Message>>().requestItems();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.message.senderDisplayName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(widget.message.message),
        SizedBox(height: 4),
      ],
    );
  }
}
