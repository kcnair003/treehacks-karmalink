import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehacks2021/blocs/auth/auth.dart';
import '../widgets/obscurable_text_field.dart';
import 'package:provider/provider.dart';
import 'package:treehacks2021/blocs/auth/auth.dart';

import '../my_navigator.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SignInWithEmailAndPassword();
    // return Scaffold(
    //   appBar: AppBar(
    //     automaticallyImplyLeading: false,
    //     title: Text('Sign in'),
    //   ),
    //   body: Center(
    //     child: Padding(
    //       padding: const EdgeInsets.all(16),
    //       child: Column(
    //         children: [
    //           ElevatedButton(
    //             onPressed: () => MyNavigator.push(
    //               SignInWithEmailAndPassword(),
    //             ),
    //             child: Text('Sign in with email and password'),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}

class SignInWithEmailAndPassword extends StatefulWidget {
  SignInWithEmailAndPassword({Key key}) : super(key: key);

  @override
  _SignInWithEmailAndPasswordState createState() =>
      _SignInWithEmailAndPasswordState();
}

class _SignInWithEmailAndPasswordState
    extends State<SignInWithEmailAndPassword> {
  final _emailController =
      TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign into Monaco'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Selector<AuthCubit, String>(
            selector: (context, cubit) =>
                cubit.state.signInWithEmailAndPasswordError,
            builder: (context, errorMessage, _) => ListView(
              children: [
                SizedBox(height: 8),
                if (errorMessage != null) ...[
                  Text(
                    errorMessage,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red[700],
                    ),
                  ),
                  SizedBox(height: 16),
                ],
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                SizedBox(height: 16),
                ObscurableTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthCubit>().signInWithEmailAndPassword(
                        _emailController.text, _passwordController.text);
                  },
                  child: Text('Submit'),
                ),
                SizedBox(height: 32),
                Text(
                  'New here?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => MyNavigator.push(
                    CreateAccountWithEmailAndPassword(),
                  ),
                  child: Text('Create an account'),
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => MyNavigator.push(
                    ForgotPasswordView(),
                  ),
                  child: Text('Forgot password'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CreateAccountWithEmailAndPassword extends StatefulWidget {
  CreateAccountWithEmailAndPassword({Key key}) : super(key: key);

  @override
  _CreateAccountWithEmailAndPasswordState createState() =>
      _CreateAccountWithEmailAndPasswordState();
}

class _CreateAccountWithEmailAndPasswordState
    extends State<CreateAccountWithEmailAndPassword> {
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _displayNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create an account'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Selector<AuthCubit, String>(
            selector: (context, cubit) => cubit.state.createAnAccountError,
            builder: (context, errorMessage, _) => ListView(
              children: [
                if (errorMessage != null) ...[
                  Text(
                    errorMessage,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red[700],
                    ),
                  ),
                  SizedBox(height: 16),
                ],
                TextFormField(
                  controller: _displayNameController,
                  decoration: InputDecoration(
                    labelText: 'Display Name',
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                SizedBox(height: 16),
                ObscurableTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthCubit>().createUserWithEmailAndPassword(
                        _displayNameController.text,
                        _emailController.text,
                        _passwordController.text);
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordView extends StatefulWidget {
  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot password'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Selector<AuthCubit, String>(
            selector: (context, cubit) => cubit.state.forgotPasswordError,
            builder: (context, errorMessage, _) => ListView(
              children: [
                if (errorMessage != null) ...[
                  Text(
                    errorMessage,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red[700],
                    ),
                  ),
                  SizedBox(height: 16),
                ],
                Text(
                  'We\'ll send a password-reset email to you',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthCubit>().sendPasswordResetEmail(
                          _emailController.text,
                        );
                  },
                  child: Text('Send'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
