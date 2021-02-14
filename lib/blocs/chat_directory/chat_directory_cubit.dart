import 'package:bloc/bloc.dart';
import 'package:treehacks2021/blocs/chat/chat.dart';
import 'package:treehacks2021/models/models.dart';
import 'package:treehacks2021/services/services.dart';

import 'chat_directory_state.dart';

class ChatDirectoryCubit extends Cubit<ChatDirectoryState> {
  ChatDirectoryCubit(String myUid, this.chatCubit)
      : super(ChatDirectoryState()) {
    _init(myUid);
  }

  final ChatCubit chatCubit;

  final _firestoreService = FirestoreService();

  void _init(String myUid) async {
    List<Group> groups = await _firestoreService.getGroups(myUid);
    List<Group> groupsWithFetchedMembers = [];

    for (var group in groups) {
      groupsWithFetchedMembers.add(await group.queryMemberData());
    }

    chatCubit.setCurrentGroup(groupsWithFetchedMembers[0]);
    emit(ChatDirectoryState(
      status: Status.loaded,
      groups: groupsWithFetchedMembers,
    ));
  }
}
