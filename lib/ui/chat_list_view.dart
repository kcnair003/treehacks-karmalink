import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_finder/blocs/auth/auth.dart';
import 'package:oil_finder/blocs/pagination/pagination.dart';
import 'package:oil_finder/models/models.dart';
import 'package:oil_finder/ui/widgets/post_view.dart';
import 'package:provider/provider.dart';
import '../constants.dart';

class ChatListView extends StatelessWidget {
  ChatListView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        // Query query = _parseQuery(
        //   context.read<AuthCubit>().state.user.uid,
        //   title,
        // );
        return PaginationCubit<Post>(
          null,
          (QueryDocumentSnapshot snapshot) {
            return Post();
            // return Post.fromSnapshot(snapshot);
          },
          [
            Post(
              displayName: 'Spencer',
              content: 'Whatsup bitches',
            ),
            Post(),
            Post(),
            Post(),
            Post(),
            Post(),
            Post(),
            Post(),
            Post(),
            Post(),
            Post(),
            Post(),
            Post(),
            Post(),
            Post(),
            Post(),
            Post(),
            Post(),
            Post(),
            Post(),
            Post(),
            Post(),
            Post(),
            Post(),
          ],
        );
      },
      child: BlocBuilder<PaginationCubit<Post>, PaginationState>(
        builder: (context, state) {
          if (state.status == PaginationLifeCycle.loading) {
            return SizedBox.shrink();
          }

          // return SliverList(
          //   delegate: SliverChildBuilderDelegate(
          //     (context, index) {
          //       return PostView(
          //         index: index,
          //         post: state.items[index],
          //       );
          //     },
          //     childCount: state.items.length,
          //   ),
          // );
          return ListView.builder(
            reverse: true,
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              return PostView(
                index: index,
                post: state.items[index],
              );
            },
          );
        },
      ),
    );
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
