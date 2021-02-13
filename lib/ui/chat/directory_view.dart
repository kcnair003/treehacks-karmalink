import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:temporary/constants/numbers.dart';
import 'package:temporary/models/group_model.dart';
import 'package:temporary/services/cloud_functions_service.dart';
import 'package:temporary/ui/project_level_data.dart';
import 'package:temporary/ui/widgets/creation_aware_list_item.dart';
import 'package:temporary/viewmodels/directory_view_model.dart';

class DirectoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ViewModelBuilder<DirectoryViewModel>.reactive(
          viewModelBuilder: () {
            return DirectoryViewModel(
              uid: ProjectLevelData.user.uid,
            );
          },
          onModelReady: (model) => model.listenToItems(),
          builder: (context, model, _) {
            if (model.busy) {
              return CircularProgressIndicator();
            }

            return ListView.builder(
              itemCount: model.items.length,
              itemBuilder: (BuildContext context, int index) {
                return CreationAwareListItem(
                  itemCreated: () {
                    print(index);
                    // Request more data when the created item is at the nth index
                    if (index % itemsPerQuery == 0) {
                      model.requestMoreData();
                    }
                  },
                  child: DirectoryListItem(
                    conversationData: model.items[index],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class DirectoryListItem extends StatelessWidget {
  DirectoryListItem({Key key, this.conversationData}) : super(key: key);

  final GroupModel conversationData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<DirectoryViewModel>().goToConversation(
              context,
              conversationData,
            );
      },
      child: Column(
        children: [
          Text(conversationData.groupName),
          Divider(thickness: 1),
        ],
      ),
    );
  }
}
