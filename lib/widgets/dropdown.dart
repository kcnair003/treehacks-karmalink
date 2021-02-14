import 'package:flutter/material.dart';
import 'package:treehacks2021/blocs/home/home_cubit.dart';

class MyDropDown extends StatefulWidget {
  MyDropDown({Key key}) : super(key: key);

  @override
  _MyDropDownState createState() => _MyDropDownState();
}

class _MyDropDownState extends State<MyDropDown> {
  Widget build(BuildContext context) => build1(context);

  @override
  Widget build1(BuildContext context) {
    return DropdownButton(
      value: true,
      iconEnabledColor: Colors.white,
      underline: Container(
        height: 2,
        color: Colors.white,
      ),
      // onChanged: (_) => context.read<HomeCubit>().toggleLikeMinded(),
      items: [
        DropdownMenuItem(
          value: true,
          child: Text('like-minded'),
        ),
        DropdownMenuItem(
          value: false,
          child: Text('different-minded'),
        ),
      ],
    );
  }
}
