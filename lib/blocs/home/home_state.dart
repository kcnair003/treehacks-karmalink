import 'package:equatable/equatable.dart';
import 'package:treehacks2021/models/models.dart';

class HomeState extends Equatable {
  final UserK user;

  HomeState({this.user});

  HomeState copyWith({
    UserK user,
  }) {
    return HomeState(
      user: user ?? this.user,
    );
  }

  @override
  List<Object> get props => [user];
}
