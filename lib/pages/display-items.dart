import 'package:flutter/material.dart';

List<Widget> feedsListItems = [
  TextField(
    decoration: InputDecoration(
      hintText: 'Post Something...',
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
            Icons.add,
            color: Colors.black,
          ),
          Text(
            "POST",
            style: TextStyle(color: Colors.black),
          ),
        ],
      ))
];
