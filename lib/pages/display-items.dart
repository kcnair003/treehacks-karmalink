import 'package:flutter/material.dart';

List<Widget> feedsListItems = [
  TextField(
    decoration: InputDecoration(
      hintText: 'Write Something...',
      contentPadding: EdgeInsets.all(20.0),
    ),
  ),
  OutlinedButton(
      onPressed: () {
        // Respond to button press
      },
      child: Row(
        children: [
          Icon(
            Icons.post_add_rounded,
            color: Colors.black,
          ),
          Text(
            "Make a Post",
            style: TextStyle(color: Colors.black),
          ),
        ],
      ))
];
