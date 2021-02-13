import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants/numbers.dart';
import '../../services/dialogflow_service.dart';
import '../../services/firestore_service.dart';
import '../../viewmodels/chatbot_view_model.dart';
import '../colors.dart';
import '../project_level_data.dart';
import '../size_config.dart';
import '../widgets/creation_aware_list_item.dart';
import '../../models/message_model.dart';

class ChatbotView extends StatelessWidget {
  ChatbotView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var result = HesprBotResult(
      showKeyboard: false,
      stringButtons: ['1', '2', '3'],
    );
    var result1 = HesprBotResult(
      showKeyboard: true,
      stringButtons: ['Yes', 'No'],
      imageButtons: {
        'assets/notebook.svg': 'Gratitude',
        'assets/road.svg': '',
      },
    );
    var result2 = HesprBotResult(
      showKeyboard: true,
      showSlider: true,
      sliderRangeStart: 4,
      sliderRangeEnd: 75,
    );
    var result3 = HesprBotResult(
      showKeyboard: false,
      stringButtons: ['Yes', 'No'],
      showSlider: true,
      sliderRangeStart: 6,
      sliderRangeEnd: 8,
    );
    return Scaffold(
      backgroundColor: backgroundGrey,
      body: Center(
        child: ViewModelBuilder<ChatbotViewModel>.reactive(
          viewModelBuilder: () => ChatbotViewModel(
            type: ItemType.message,
            uid: ProjectLevelData.user.uid,
          ),
          onModelReady: (model) => model.listenToItems(),
          builder: (context, model, child) => model.busy
              ? CircularProgressIndicator()
              : Column(
                  children: [
                    Expanded(
                      child: messagesScrollView(model),
                    ),
                    MyTextField(),
                  ],
                ),
        ),
      ),
    );
  }

  Widget messagesScrollView(ChatbotViewModel model) {
    return ListView.builder(
      itemCount: model.items.length,
      itemBuilder: (context, index) {
        return CreationAwareListItem(
          itemCreated: () {
            print(index);
            // Request more data when the created item is at the nth index
            if (index % postsPerQuery == 0) {
              model.requestMoreData();
            }
          },
          child: paddedMessage(index, model),
        );
      },
    );
  }

  /// Return a message, and add padding to the bottom if it's the last message.
  Widget paddedMessage(index, model) {
    if (index == model.items.length - 1) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Message(messageModel: model.items[index]),
      );
    } else {
      return Message(messageModel: model.items[index]);
    }
  }

  Widget fakeListView() {
    List strings = [
      'a',
      'b',
      'c',
      'd',
      'e',
      'f',
      'g',
      'h',
      'i',
      'j',
      'k',
      'l',
      'm'
    ];
    return ListView.builder(
      itemCount: strings.length,
      itemBuilder: (context, index) {
        return Text(
          strings[index],
          style: TextStyle(
            fontSize: 50,
          ),
        );
      },
    );
  }
}

class Message extends StatelessWidget {
  Message({this.messageModel});

  final MessageModel messageModel;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: Row(
        mainAxisAlignment: messageModel.isMine
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Visibility(
            visible: !messageModel.isMine,
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/logo1.png'),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            constraints:
                BoxConstraints(minHeight: 10, minWidth: 40, maxWidth: 230),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(13.0),
              ),
              color: messageModel.isMine
                  ? Color.fromRGBO(143, 219, 210, 1)
                  : Color.fromRGBO(230, 230, 230, 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(left: 16, right: 16, top: 6, bottom: 6),
                  child: Text(
                    messageModel.message,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        color: messageModel.isMine
                            ? Colors.white
                            : Colors.grey[700],
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
            width: 340,
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
          child: Consumer<ChatbotViewModel>(
            builder: (context, model, _) => GestureDetector(
              onTap: () => sendMessage(model),
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

  void sendMessage(ChatbotViewModel model) {
    var messageModel = MessageModel(
      message: controller.text,
      uid: ProjectLevelData.user.uid,
      isMine: true,
      timestamp: FieldValue.serverTimestamp(),
    );
    model.sendChatbotMessage(messageModel);
  }
}
