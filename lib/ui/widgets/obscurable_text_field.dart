import 'package:flutter/material.dart';
import '../ui_helper.dart';

class ObscurableTextField extends StatefulWidget {
  ObscurableTextField({Key key, @required this.controller, this.labelText})
      : assert(controller != null),
        super(key: key);

  final TextEditingController controller;
  final String labelText;

  @override
  _ObscurableTextFieldState createState() => _ObscurableTextFieldState();
}

class _ObscurableTextFieldState extends State<ObscurableTextField> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
            labelText: widget.labelText,
          ),
          obscureText: obscure,
        ),
        SizedBox(height: 4),
        Row(
          children: [
            Checkbox(
              onChanged: (bool value) {
                setState(() {
                  obscure = !obscure;
                });
              },
              value: !obscure,
              activeColor: context.theme.primaryColor,
            ),
            Text('Show password'),
          ],
        ),
      ],
    );
  }
}
