import 'package:equatable/equatable.dart';

import 'package:treehacks2021/models/models.dart';

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
