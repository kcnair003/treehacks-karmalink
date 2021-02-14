import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehacks2021/blocs/auth/auth.dart';
import 'package:treehacks2021/blocs/pagination/pagination.dart';
import 'package:treehacks2021/models/models.dart';
import 'package:treehacks2021/models/src/message.dart';
import 'package:treehacks2021/services/services.dart';
import 'package:provider/provider.dart';

import 'message_view.dart';

class ChatListView extends StatelessWidget {
  ChatListView({Key key, this.group}) : super(key: key);

  final Group group;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Message>>(
      // create: (_) => FirestoreService().getMessages(group.id),
      create: (_) => FirestoreService().getMessages('YZg73r8JMsGNUVVEuxTn'),
      builder: (context, _) {
        List<Message> messages = context.watch<List<Message>>();
        if (messages == null) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return MessageView(
              index: index,
              message: messages[index],
            );
          },
        );
      },
    );
    // return BlocProvider(
    //   create: (_) {
    //     // Query query = _parseQuery(
    //     //   context.read<AuthCubit>().state.user.uid,
    //     //   title,
    //     // );
    //     return PaginationCubit<Post>(
    //       null,
    //       (QueryDocumentSnapshot snapshot) {
    //         return Post();
    //         // return Post.fromSnapshot(snapshot);
    //       },
    //       [
    //         Post(
    //           displayName: 'Spencer',
    //           content: 'Whatsup bitches',
    //         ),
    //         Post(),
    //         Post(),
    //         Post(),
    //         Post(),
    //         Post(),
    //         Post(),
    //         Post(),
    //         Post(),
    //         Post(),
    //         Post(),
    //         Post(),
    //         Post(),
    //         Post(),
    //         Post(),
    //         Post(),
    //         Post(),
    //         Post(),
    //         Post(),
    //         Post(),
    //         Post(),
    //         Post(),
    //         Post(),
    //         Post(),
    //       ],
    //     );
    //   },
    //   child: BlocBuilder<PaginationCubit<Post>, PaginationState>(
    //     builder: (context, state) {
    //       if (state.status == PaginationLifeCycle.loading) {
    //         return SizedBox.shrink();
    //       }

    //       // return SliverList(
    //       //   delegate: SliverChildBuilderDelegate(
    //       //     (context, index) {
    //       //       return PostView(
    //       //         index: index,
    //       //         post: state.items[index],
    //       //       );
    //       //     },
    //       //     childCount: state.items.length,
    //       //   ),
    //       // );
    //       return ListView.builder(
    //         reverse: true,
    //         itemCount: state.items.length,
    //         itemBuilder: (context, index) {
    //           return MessageView(
    //             index: index,
    //             message: state.items[index],
    //           );
    //         },
    //       );
    //     },
    //   ),
    // );
  }

  Query _parseQuery(String uid, String title) {
    throw UnimplementedError();
    // CollectionReference collection = FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(uid)
    //     .collection('myItems');
    // Query filtered;
    // if (title == 'All of My Items') {
    //   filtered = collection;
    // } else if (title == 'Favorites') {
    //   filtered = collection.where(
    //     FirestoreConsts.categoriesTheItemBelongsIn,
    //     arrayContains: FirestoreConsts.favorites,
    //   );
    // } else if (title == 'Wish List') {
    //   filtered = collection.where(
    //     FirestoreConsts.categoriesTheItemBelongsIn,
    //     arrayContains: FirestoreConsts.wishList,
    //   );
    // } else {
    //   filtered = collection.where(
    //     FirestoreConsts.categoriesTheItemBelongsIn,
    //     arrayContains: title,
    //   );
    // }
    // var sorted = filtered.orderBy('name');
    // return sorted;
  }
}
