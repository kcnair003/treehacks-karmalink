import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import '../constants/numbers.dart';

typedef Object ModelConstructor(QueryDocumentSnapshot snapshot);

class Pagination {
  StreamSubscription _subscription;
  BehaviorSubject<List<dynamic>> _itemsController = BehaviorSubject();

  DocumentSnapshot _lastDocument;
  List<List<dynamic>> _allPagedResults = List();
  bool _hasMorePosts = true;

  Stream listenToItemsRealTime(Query query, ModelConstructor modelConstructor) {
    requestItems(query, modelConstructor);
    return _itemsController.stream;
  }

  void requestItems(Query query, ModelConstructor modelConstructor) async {
    var pageItemsQuery = query;

    if (_lastDocument != null) {
      pageItemsQuery = pageItemsQuery.startAfterDocument(_lastDocument);
    }

    var snapshots = pageItemsQuery.snapshots();

    // If there's no more items then bail out of the function
    if (!_hasMorePosts) return;

    var currentRequestIndex = _allPagedResults.length;

    _subscription = snapshots.listen((postsSnapshot) {
      // Return no items if there are none to begin with
      if (postsSnapshot.docs.isEmpty) {
        _itemsController.add(List<dynamic>());
        return;
      }

      var items = postsSnapshot.docs.map((QueryDocumentSnapshot snapshot) {
        return modelConstructor(snapshot);
      }).toList();

      var pageExists = currentRequestIndex < _allPagedResults.length;

      if (pageExists) {
        _allPagedResults[currentRequestIndex] = items;
      } else {
        _allPagedResults.add(items);
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
      _hasMorePosts = items.length == itemsPerQuery;
    }, onError: (error) {
      print(error);
    });
  }

  void stopListening() {
    _subscription.cancel();
  }
}
