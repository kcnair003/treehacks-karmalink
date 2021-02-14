import 'package:flutter/material.dart';
import '../../blocs/pagination/pagination.dart';
import '../../models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostView extends StatefulWidget {
  PostView({Key key, this.index, this.post}) : super(key: key);

  final int index;
  final Post post;

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  @override
  void initState() {
    super.initState();
    // if (widget.index % 20 == 0) {
    //   context.read<PaginationCubit<Post>>().requestItems();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.post.displayName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(widget.post.content),
        SizedBox(height: 4),
      ],
    );
  }
}
