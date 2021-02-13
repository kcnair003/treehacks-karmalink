import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:temporary/constants/constants.dart';
import '../models/message_model.dart';
import '../models/user.dart';
import '../models/post_card_model.dart';
import 'package:flutter/services.dart';
import '../constants/numbers.dart';
import '../ui/project_level_data.dart';
import '../models/profile_model.dart';
import '../ui/social_platform/profile.dart';

enum ItemType {
  post,
  friend,
  friendRequest,
  message,
}

class FirestoreService {
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _postsCollectionReference =
      FirebaseFirestore.instance.collection('posts');

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel> getCurrentUserData() async {
    final User user = _auth.currentUser;
    final uid = user.uid;
    return await getUserData(uid);
  }

  Future<UserModel> getUserData(String uid) async {
    var snapshot = await _usersCollectionReference.doc(uid).get();
    var data = snapshot.data();
    return UserModel.fromMap(data);
  }

  void updateUserDocumentOnLogin(UserModel user) async {
    _usersCollectionReference.doc(user.uid).set(
      {
        'nickname': user.displayName,
        'photoUrl': user.photoUrl,
        'email': user.email,
        'id': user.uid,
        'release_version': Constants.releaseVersion,
        'requested_delete': false,
        'approved_delete': false,
      },
      SetOptions(merge: true),
    );
  }

  void updateUserDocument(String uid, Map<String, dynamic> data) async {
    _usersCollectionReference.doc(uid).update(data);
  }

  Future<ProfileModel> constructProfileModel(String uid) async {
    var user = await _usersCollectionReference.doc(uid).get();
    var data = user.data();

    return await ProfileModel.fromMap(data, uid);
  }

  BehaviorSubject<List<dynamic>> _itemsController;

  DocumentSnapshot _lastDocument;
  // Paged structure
  List<List<dynamic>> _allPagedResults;
  bool _hasMorePosts;

  Stream listenToItemsRealTime(String uid, ItemType type) {
    // Reset fields in between post queries
    _lastDocument = null;
    _allPagedResults = List<List<dynamic>>();
    _hasMorePosts = true;
    _itemsController = BehaviorSubject<List<dynamic>>();

    _requestItems(uid, type);
    print('items requested');
    return _itemsController.stream;
  }

  void _requestItems(String uid, ItemType type) async {
    var pageItemsQuery = chooseQuery(uid, type);

    if (_lastDocument != null) {
      pageItemsQuery = pageItemsQuery.startAfterDocument(_lastDocument);
    }

    var snapshots = pageItemsQuery.snapshots();

    // If there's no more items then bail out of the function
    if (!_hasMorePosts) return;

    var currentRequestIndex = _allPagedResults.length;

    snapshots.listen((postsSnapshot) {
      // Return no posts if there are none to begin with
      if (postsSnapshot.docs.isEmpty) {
        _itemsController.add(List<dynamic>());
        return;
      }

      var posts = postsSnapshot.docs.map((snapshot) {
        return chooseModel(type, snapshot);
      }).toList();

      var pageExists = currentRequestIndex < _allPagedResults.length;

      if (pageExists) {
        _allPagedResults[currentRequestIndex] = posts;
      } else {
        _allPagedResults.add(posts);
      }

      // Lowkey I don't understand this line at all
      var allItems = _allPagedResults.fold<List<dynamic>>(List<dynamic>(),
          (initialValue, pageItems) => initialValue..addAll(pageItems));

      _itemsController.add(allItems);

      // Save the last document from the results only if it's the current last page
      if (currentRequestIndex == _allPagedResults.length - 1) {
        _lastDocument = postsSnapshot.docs.last;
      }

      // Determine if there's more posts to request
      _hasMorePosts = posts.length == postsPerQuery;
    }, onError: (error) {
      print(error);
    });
  }

  dynamic chooseModel(ItemType type, QueryDocumentSnapshot snapshot) {
    switch (type) {
      case ItemType.post:
        return PostCardModel.fromMap(snapshot.data(), snapshot.id);
      case ItemType.message:
        return MessageModel.fromMap(snapshot.data());
      case ItemType.friendRequest:
        return RequestListItemModel.fromMap(snapshot.data(), snapshot.id);
      case ItemType.friend:
        return FriendListItemModel.fromMap(snapshot.data(), snapshot.id);
      default:
        throw 'Attempted to return model for an invalid item type.';
    }
  }

  Query chooseQuery(String uid, ItemType type) {
    switch (type) {
      case ItemType.post:
        {
          var _filteredQuery = (uid == null) || (uid == '')
              ? _postsCollectionReference
              : _postsCollectionReference.where('uid', isEqualTo: uid);
          var pagePostsQuery = _filteredQuery
              .orderBy('timestamp', descending: true)
              .limit(postsPerQuery);
          return pagePostsQuery;
        }
      case ItemType.message:
        {
          var _messagesQuery = _usersCollectionReference
              .doc(uid)
              .collection('chatConversations')
              .doc('chatbot')
              .collection('messages')
              .orderBy('timestamp', descending: true)
              .limit(postsPerQuery);
          return _messagesQuery;
        }
      case ItemType.friend:
        {
          var _pageFriendsQuery = _usersCollectionReference
              .doc(uid)
              .collection('friends')
              .orderBy('nickname')
              .limit(postsPerQuery);
          return _pageFriendsQuery;
        }
      case ItemType.friendRequest:
        {
          var _pageRequestsQuery = _usersCollectionReference
              .doc(uid)
              .collection('incoming_friend_requests')
              .orderBy('timestamp', descending: true)
              .limit(postsPerQuery);
          return _pageRequestsQuery;
        }
      default:
        {
          throw 'Invalid item type for paginated data.';
        }
    }
  }

  Future deletePost(String documentId) async {
    await _postsCollectionReference.doc(documentId).delete();
  }

  Future editPost(String documentId, String content) async {
    try {
      await _postsCollectionReference.doc(documentId).update({
        'content': content,
      });
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future reportPost(String documentId) async {
    await _postsCollectionReference.doc(documentId).update({
      'report': FieldValue.increment(1),
    });
  }

  /// Update the value for [reaction] in firestore. And add or remove uid in
  /// the subcollection for whichever reaction they chose.
  Future updateReaction(
      String documentId, String reaction, bool clicked) async {
    await _postsCollectionReference.doc(documentId).update({
      reaction: FieldValue.increment(clicked ? -1 : 1),
    });

    // Post document > reaction collection > set or delete document with uid
    var userReaction = _postsCollectionReference
        .doc(documentId)
        .collection(reaction)
        .doc(ProjectLevelData.user.uid);
    clicked ? await userReaction.delete() : await userReaction.set({});
  }

  /// Query the reaction collection for the post and see if the user has
  /// selected that reaction.
  Future<bool> getReactionSelected(String postID, String reaction) async {
    var postDoc = _postsCollectionReference.doc(postID);

    var exists = false;
    await postDoc
        .collection(reaction)
        .doc(ProjectLevelData.user.uid)
        .get()
        .then((doc) {
      exists = doc.exists;
    });

    return exists;
  }

  void requestMoreData(String uid, ItemType type) => _requestItems(uid, type);

  /// Emit the user data associated with `uid` as a stream.
  Stream<DocumentSnapshot> userDataStream(String uid) {
    return _usersCollectionReference.doc(uid).snapshots();
  }

  Future<String> getFriendStatus(String viewerUid, String profileUid) async {
    var viewer = _usersCollectionReference.doc(viewerUid);
    var profile = _usersCollectionReference.doc(profileUid);

    var friendSnapshot =
        await viewer.collection('friends').doc(profileUid).get();

    if (friendSnapshot.exists) {
      return 'Friends';
    }

    var requestSnapshot = await profile
        .collection('incoming_friend_requests')
        .doc(viewerUid)
        .get();

    if (requestSnapshot.exists) {
      return 'Request sent';
    }

    return 'Not friends';
  }

  Future requestFriend(String sender, String reciever) async {
    var user = _usersCollectionReference.doc(reciever);

    user.collection('incoming_friend_requests').doc(sender).set({
      'timestamp': FieldValue.serverTimestamp(),
      'nickname': ProjectLevelData.user.displayName,
      'photoUrl': ProjectLevelData.user.photoUrl,
    });

    var snapshot = await user.get();
    bool exists = snapshot.data().containsKey('incoming_friend_requests');

    user.update({
      'incoming_friend_requests': exists ? FieldValue.increment(1) : 1,
    });
  }

  void cancelRequest(String sender, String reciever) {
    var user = _usersCollectionReference.doc(reciever);

    user.collection('incoming_friend_requests').doc(sender).delete();

    user.update({
      'incoming_friend_requests': FieldValue.increment(-1),
    });
  }

  /// Accept or reject a friend request.
  void handleRequestResponse(
    String accepterUid,
    RequestListItemModel requesterModel,
    bool accept,
  ) async {
    var accepterDoc = _usersCollectionReference.doc(accepterUid);
    var requesterDoc =
        _usersCollectionReference.doc(requesterModel.requesterUid);

    // Add to friends for both parties if accepted
    if (accept) {
      accepterDoc.collection('friends').doc(requesterModel.requesterUid).set({
        'nickname': requesterModel.nickname,
        'photoUrl': requesterModel.photoUrl,
      });
      requesterDoc.collection('friends').doc(accepterUid).set({
        'nickname': ProjectLevelData.user.displayName,
        'photoUrl': ProjectLevelData.user.photoUrl,
      });
    }

    // Remove from incoming
    await accepterDoc
        .collection('incoming_friend_requests')
        .doc(requesterModel.requesterUid)
        .delete();

    accepterDoc.update({
      'incoming_friend_requests': FieldValue.increment(-1),
    });
  }

  void removeFriend(String remover, String userToRemove) {
    _usersCollectionReference
        .doc(remover)
        .collection('friends')
        .doc(userToRemove)
        .delete();

    _usersCollectionReference
        .doc(userToRemove)
        .collection('friends')
        .doc(remover)
        .delete();
  }

  void createChatbotMessage(MessageModel message) {
    var data = message.toMap();

    _usersCollectionReference
        .doc(ProjectLevelData.user.uid)
        .collection('chatConversations')
        .doc('chatbot')
        .collection('messages')
        .add(data);
  }
}
