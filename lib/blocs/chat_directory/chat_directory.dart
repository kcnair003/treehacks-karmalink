import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:treehacks2021/models/src/group.dart';
import 'package:treehacks2021/models/src/user.dart';
import 'package:treehacks2021/services/services.dart';

class ChatDirectoryCubit extends Cubit<ChatDirectoryState> {
  ChatDirectoryCubit(String myUid) : super(ChatDirectoryState()) {
    _init(myUid);
  }

  final _firestoreService = FirestoreService();

  void _init(String myUid) async {
    List<Group> groups = await _firestoreService.getGroups(myUid);
    for (var group in groups) {
      await group.queryMemberData();
    }
    emit(ChatDirectoryState(
      status: Status.loaded,
      groups: groups,
    ));
  }
}

enum Status {
  loading,
  loaded,
}

class ChatDirectoryState extends Equatable {
  final Status status;
  final List<Group> groups;

  ChatDirectoryState({
    this.status = Status.loading,
    this.groups = const [],
  });

  @override
  List<Object> get props => [status, groups];

  ChatDirectoryState copyWith({
    Status status,
    List<Group> groups,
  }) {
    return ChatDirectoryState(
      status: status ?? this.status,
      groups: groups ?? this.groups,
    );
  }
}
