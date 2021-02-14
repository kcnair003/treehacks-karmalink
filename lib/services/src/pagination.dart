import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

typedef T ModelConstructor<T>(QueryDocumentSnapshot snapshot);

class Pagination {
  DocumentSnapshot _lastDocument;
  List _allPagedResults = [];
  int _currentRequestIndex;
  bool _hasMoreItems = true;

  void reset() {
    _lastDocument = null;
    _allPagedResults = [];
    _currentRequestIndex = null;
    _hasMoreItems = true;
  }

  Future<List<T>> requestItems<T>(
      Query query, ModelConstructor modelConstructor) async {
    if (!_hasMoreItems) return [];

    Query pageItemsQuery = query;

    if (_lastDocument != null) {
      pageItemsQuery = pageItemsQuery.startAfterDocument(_lastDocument);
    }

    QuerySnapshot snapshot = await pageItemsQuery.get();

    if (snapshot.docs.isEmpty) return [];

    List<T> items = snapshot.docs.map<T>((QueryDocumentSnapshot snapshot) {
      return modelConstructor(snapshot);
    }).toList();

    _allPagedResults.addAll(items);

    if (_currentRequestIndex == _allPagedResults.length - 1) {
      _currentRequestIndex = _allPagedResults.length;
    }

    _currentRequestIndex = _allPagedResults.length;

    _hasMoreItems = items.length == 10;

    return items;
  }
}
