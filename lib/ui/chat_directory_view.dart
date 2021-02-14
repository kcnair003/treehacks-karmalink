import 'package:flutter/material.dart';
import 'package:oil_finder/models/models.dart';
import 'package:oil_finder/services/services.dart';

class ChatDirectoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // List<Group> groups = [
    //   Group(
    //     memberUids: ['Spencer', 'Krishna'],
    //   ),
    //   Group(
    //     memberUids: ['Spencer', 'Jon Doe'],
    //   ),
    //   Group(
    //     memberUids: ['Spencer', 'Mani'],
    //   ),
    // ];
    return FutureBuilder(
      future: FirestoreService().getGroups('ES6LePcMMnHgyChcPwYf'),
      builder: (context, asyncSnapshot) {
        if (!asyncSnapshot.hasData) {
          return SizedBox.shrink();
        } else {
          List<Group> groups = asyncSnapshot.data;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) => GroupView(
                chatGroup: groups[index],
              ),
            ),
          );
        }
      },
    );
  }
}

class GroupView extends StatelessWidget {
  GroupView({Key key, this.chatGroup}) : super(key: key);

  final Group chatGroup;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor,
              blurRadius: 4,
            ),
          ],
        ),
        child: Text(chatGroup.memberUids.join(', ')),
      ),
    );
  }
}
