import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'creation_aware_list_item.dart';
import '../../viewmodels/paginated_scroll_view_model.dart';
import 'post_card.dart';
import '../../constants/numbers.dart';

class PostsScrollView extends StatelessWidget {
  const PostsScrollView({Key key, this.uid = ''}) : super(key: key);

  /// Which user to show posts for.
  final String uid;

  @override
  Widget build(BuildContext context) {
    return Consumer<PaginatedScrollViewModel>(
      builder: (context, model, _) => SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return CreationAwareListItem(
              itemCreated: () {
                print(index);
                // Request more data when the created item is at the nth index
                if (index % postsPerQuery == 0) {
                  model.requestMoreData();
                }
              },
              child: PostCard(
                post: model.items[index],
              ),
            );
          },
          childCount: model.items.length,
        ),
      ),
    );
  }
}
