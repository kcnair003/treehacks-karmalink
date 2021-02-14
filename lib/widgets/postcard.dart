import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  PostCard(this.content, this.poster);
  final String content;
  final String poster;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(22, 15, 22, 15),
        child: Row(children: [
          Icon(
            Icons.person,
            size: 60,
            color: Colors.lightBlue[100],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(poster,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black54)),
              SizedBox(
                height: 3,
              ),
              Text(
                content,
                textScaleFactor: 1.2,
              ),
              Row(
                children: [
                  Icon(Icons.how_to_vote_outlined),
                  Icon(Icons.star_rate_rounded),
                ],
              )
            ],
          ),
        ]),
      ),
    );
  }
}
