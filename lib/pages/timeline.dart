import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:treehacks2021/widgets/header.dart';
import 'package:treehacks2021/widgets/progress.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  void initState() {
    getUsers();
    super.initState();
  }
  
  getUsers() async {
    final QuerySnapshot documents = await usersRef.get();
    
    documents.docs.forEach((DocumentSnapshot doc) {
      print(doc.data());
    });
    
  }

  @override
  Widget build(context) {
    return Column(
      children: <Widget>[
        header(),
        //linearProgress(),
        Container(),
      ]
    );
  }
}
