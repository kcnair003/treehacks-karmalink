import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/conversation_view_model.dart';
import '../size_config.dart';

class MyTextField extends StatelessWidget {
  MyTextField({Key key}) : super(key: key);
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
            width: SizeConfig.h * 80,
            child: TextFormField(
              controller: controller,
              minLines: 1,
              maxLines: 4,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 22, vertical: 15),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                hintText: 'You can type here...',
                filled: true,
                fillColor: Colors.grey[300],
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<ConversationViewModel>(
            builder: (context, model, _) => GestureDetector(
              onTap: () {
                model.sendMessage(controller.text);
              },
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.purple[100],
                ),
                child: Icon(
                  Icons.send,
                  color: Colors.purple,
                  size: 24.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // void sendMessage(ChatbotViewModel model) {
  //   var messageModel = MessageModel(
  //     message: controller.text,
  //     uid: ProjectLevelData.user.uid,
  //     isMine: true,
  //     timestamp: FieldValue.serverTimestamp(),
  //   );
  //   model.sendChatbotMessage(messageModel);
  // }
}
