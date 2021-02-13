import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:temporary/constants/numbers.dart';
import 'package:temporary/models/group_model.dart';
import 'package:temporary/ui/chat/conversation_view.dart';

import 'paginated_scroll_view_model.dart';

class DirectoryViewModel extends PaginatedScrollViewModel {
  DirectoryViewModel({String uid})
      : super(
          query: FirebaseFirestore.instance
              .collection('groups')
              .where('member_ids', arrayContains: uid)
              .orderBy('modifiedAt', descending: true)
              .limit(itemsPerQuery),
          modelConstructor: (QueryDocumentSnapshot snapshot) {
            return GroupModel.fromSnapshot(snapshot);
          },
        );

  void goToConversation(BuildContext context, GroupModel conversationData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ConversationView(
          conversationData: conversationData,
        ),
      ),
    );
  }
}
