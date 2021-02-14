import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehacks2021/blocs/chat_directory/chat_directory.dart';
import 'package:treehacks2021/models/models.dart';
import 'package:treehacks2021/services/services.dart';
import 'package:provider/provider.dart';

class ChatDirectory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatDirectoryCubit('ES6LePcMMnHgyChcPwYf'),
      child: BlocBuilder<ChatDirectoryCubit, ChatDirectoryState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListView.builder(
              itemCount: state.groups.length,
              itemBuilder: (context, index) => GroupView(
                group: state.groups[index],
              ),
            ),
          );
        },
      ),
    );
    // return FutureProvider(
    //   create: (_) => FirestoreService().getGroups('ES6LePcMMnHgyChcPwYf'),
    //   builder: (context, _) {
    //     List<Group> groups = context.watch<List<Group>>();
    //     if (groups == null) {
    //       return Center(child: CircularProgressIndicator());
    //     }
    //     return Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 8),
    //       child: ListView.builder(
    //         itemCount: groups.length,
    //         itemBuilder: (context, index) => GroupView(
    //           group: groups[index],
    //         ),
    //       ),
    //     );
    //   },
    // );
  }
}

class GroupView extends StatelessWidget {
  GroupView({Key key, this.group}) : super(key: key);

  final Group group;

  final _firestoreService = FirestoreService();

  Future<List<User>> users() async {
    List<User> users = [];
    for (var uid in group.memberUids) {
      User user = await _firestoreService.getUser(uid);
      print(user);
      users.add(user);
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    // return FutureProvider(
    //   create: (_) => users(),
    //   builder: (context, _) {
    //     List<User> users = context.watch<List<User>>();
    //     if (users == null) {
    //       return SizedBox.shrink();
    //     }
    //     return Padding(
    //       padding: const EdgeInsets.only(top: 16),
    //       child: Container(
    //         padding: const EdgeInsets.all(8.0),
    //         decoration: BoxDecoration(
    //           color: Theme.of(context).primaryColor,
    //           borderRadius: BorderRadius.circular(10),
    //           boxShadow: [
    //             BoxShadow(
    //               color: Theme.of(context).shadowColor,
    //               blurRadius: 4,
    //             ),
    //           ],
    //         ),
    //         child: Text(users.map((user) => user.displayName).join(', ')),
    //         // child: Text(group.getNamesToDisplay('ES6LePcMMnHgyChcPwYf')),
    //       ),
    //     );
    //   },
    // );
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
        // child: Text(users.map((user) => user.displayName).join(', ')),
        child: Text(group.getNamesToDisplay('ES6LePcMMnHgyChcPwYf')),
      ),
    );
  }
}
