import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/theme/theme.dart';
import 'package:provider/provider.dart';

import 'blocs/my_bloc_observer.dart';
import 'services/services.dart';
import 'ui/ui_helper.dart';
import 'locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Avoid initializing Firebase SDKs if web
  if (!kIsWeb) {
    await CrashlyticsService.initCrashlytics();
    await Firebase.initializeApp();
  }

  setupLocator();

  Bloc.observer = MyBlocObserver();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _authService = locator<FirebaseAuthService>();
  @override
  Widget build(BuildContext context) {
    // final Stream<User> user = _authService.user;
    return MultiProvider(
      providers: [
        // BlocProvider<AuthCubit>(
        //   create: (_) => AuthCubit(
        //     userStream: user,
        //   ),
        // ),
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(),
        ),
      ],
      builder: (context, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: MyNavigator.navigatorKey,
        theme: context.watch<ThemeCubit>().state,
        // home: AuthView(),
        home: Home(title: 'DialogueDen'),
      ),
    );
  }
}
