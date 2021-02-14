import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:treehacks2021/models/models.dart';
import 'package:treehacks2021/services/services.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatState());

  final _firestoreService = FirestoreService();

  void setCurrentGroup(Group group) {
    emit(state.copyWith(group: group));
    _firestoreService.getMessages(group.id).listen((List<Message> messages) {
      emit(state.copyWith(
        messages: messages,
      ));
    });
  }
}

class ChatState extends Equatable {
  /// Current group in view.
  final Group group;
  final List<Message> messages;

  ChatState({this.group, this.messages = const []});

  ChatState copyWith({
    Group group,
    List<Message> messages,
  }) {
    return ChatState(
      group: group ?? this.group,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object> get props => [group, messages];

  @override
  String toString() {
    return '$group';
  }
}
