import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:temporary/models/group_model.dart';
import 'package:temporary/ui/widgets/my_app_bar.dart';
import 'package:provider/provider.dart';

import '../../constants/numbers.dart';
import '../../viewmodels/conversation_view_model.dart';
import '../../models/message_model.dart';
import '../colors.dart';
import '../project_level_data.dart';
import '../widgets/creation_aware_list_item.dart';
import '../widgets/loading_view.dart';
import 'message.dart';
import 'my_text_field.dart';

class ConversationView extends StatelessWidget {
  ConversationView({Key key, this.conversationData}) : super(key: key);

  final GroupModel conversationData;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ConversationViewModel>.reactive(
      viewModelBuilder: () => ConversationViewModel(
        uid: ProjectLevelData.user.uid,
        groupId: conversationData.groupId,
      ),
      onModelReady: (model) => model.init(conversationData),
      builder: (context, model, _) {
        if (model.busy) {
          return LoadingView();
        }

        return Scaffold(
          backgroundColor: backgroundGrey,
          appBar: MyAppBar(
            onBack: () => Navigator.pop(context),
            titleText: conversationData.groupName,
            color: orange3,
          ),
          body: Center(
            child: Column(
              children: [
                SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: model.items.length,
                    itemBuilder: (context, index) {
                      MessageModel messageModel = model.items[index];
                      return CreationAwareListItem(
                        itemCreated: () {
                          print(index);
                          // Request more data when the created item is at the nth index
                          if (index % itemsPerQuery == 0) {
                            model.requestMoreData();
                          }

                          model.markMessageAsRead(messageModel);
                        },
                        child: Message(
                          messageModel: messageModel,
                          userModel: model.getMemberById(messageModel.sentBy),
                        ),
                      );
                    },
                  ),
                ),
                MyTextField(),
                SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}
