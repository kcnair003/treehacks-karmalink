import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final String displayName;
  final String content;

  Post({this.displayName = 'Jon Doe', this.content = 'Hello debaters!'});

  static Post fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data();
    return Post(
      displayName: data['displayName'],
      content: data['content'],
    );
  }

  @override
  List<Object> get props => [displayName, content];
}
