import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehacks2021/blocs/auth/auth.dart';

import 'home.dart';
import 'loading_view.dart';
import 'login_view.dart';

class AuthView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        if (authState.status == AuthLifeCycle.loading) {
          return LoadingView();
        } else if (authState.status == AuthLifeCycle.unauthenticated) {
          return LoginView();
        } else {
          return Home();
        }
      },
    );
  }
}
