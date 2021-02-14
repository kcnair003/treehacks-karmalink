import 'package:flutter/material.dart';
import 'package:treehacks2021/widgets/header.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      appBar: header(parentContext, "Set up your profile"),
    );
  }
}