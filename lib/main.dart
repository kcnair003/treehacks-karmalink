import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:treehacks2021/services/services.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/my_bloc_observer.dart';
import 'dynamicmodels/ThemeSelection.dart';
import 'my_navigator.dart';
import 'pages/auth_view.dart';

void main() {
  Bloc.observer = MyBlocObserver();

  runApp(ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  final _authService = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    final appName = 'KarmaLink';
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(),
        ),
        BlocProvider(
          create: (_) => AuthCubit(
            userStream: _authService.user,
          ),
        ),
      ],
      builder: (context, _) => MaterialApp(
        title: appName,
        theme: context.watch<ThemeNotifier>().selectedTheme,
        debugShowCheckedModeBanner: false,
        navigatorKey: MyNavigator.navigatorKey,
        home: AuthView(),
      ),
    );
  }
}
