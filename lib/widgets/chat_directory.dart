import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehacks2021/blocs/blocs.dart';
import 'package:treehacks2021/blocs/chat_directory/chat_directory.dart';
import 'package:treehacks2021/models/models.dart';
import 'package:treehacks2021/services/services.dart';
import 'package:provider/provider.dart';

class ChatDirectory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatDirectoryCubit(
        context.watch<AuthCubit>().state.user.uid,
        context.watch<ChatCubit>(),
      ),
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
  }
}

class GroupView extends StatelessWidget {
  GroupView({Key key, this.group}) : super(key: key);

  final Group group;

  final _firestoreService = FirestoreService();

  Future<List<UserK>> users() async {
    List<UserK> users = [];
    for (var uid in group.memberUids) {
      UserK user = await _firestoreService.getUser(uid);
      print(user);
      users.add(user);
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: GestureDetector(
        onTap: () => context.read<ChatCubit>().setCurrentGroup(group),
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
          child: Text(group.getNamesToDisplay('ES6LePcMMnHgyChcPwYf')),
        ),
      ),
    );
  }
}
