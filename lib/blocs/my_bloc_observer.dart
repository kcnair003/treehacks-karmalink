import 'package:bloc/bloc.dart';

/// Concrete implementation of [BlocObserver] which observes all Cubit and Bloc state changes.
///
/// Set instance of [MyBlocObserver] to [Bloc.obsever] in the main function
/// to print out observations, but make sure to remove from production code.
class MyBlocObserver extends BlocObserver {
  @override
  void onChange(Cubit cubit, Change change) {
    super.onChange(cubit, change);
    if (!(cubit is Bloc)) {
      print('${cubit.runtimeType} $change');
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('${bloc.runtimeType} $transition');
  }
}
