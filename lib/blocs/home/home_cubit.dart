import 'package:bloc/bloc.dart';

import 'package:treehacks2021/models/models.dart';
import 'package:treehacks2021/services/services.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(User user) : super(HomeState(user: user));

  final _firestoreService = FirestoreService();

  void toggleLikeMinded() {
    _firestoreService.updateUser(
      state.user.uid,
      {'like_minded': !state.user.likeMinded},
    );
    emit(state.copyWith(
      user: state.user.copyWith(
        likeMinded: !state.user.likeMinded,
      ),
    ));
  }
}
