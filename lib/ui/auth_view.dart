import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_finder/blocs/auth/auth.dart';
import 'package:oil_finder/ui/login_view.dart';

import 'loading_view.dart';
// import 'onboarding_view.dart';
import 'chat_list_view.dart';

class AuthView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        if (authState.status == AuthLifeCycle.loading) {
          return LoadingView();
        } else if (authState.status == AuthLifeCycle.needsOnboarded) {
          // return OnboardingView();
          return Container();
        } else if (authState.status == AuthLifeCycle.unauthenticated) {
          return LoginView();
        } else {
          return Container();
          // TODO
          // return FeedView();
        }
      },
    );
  }
}
