import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/pagination.dart';
import 'base_model.dart';

class PaginatedScrollViewModel extends BaseModel {
  PaginatedScrollViewModel({this.query, this.modelConstructor});

  // final String uid;
  final Query query;
  final ModelConstructor modelConstructor;

  List<dynamic> _items = List();
  List<dynamic> get items => _items;

  final Pagination _pagination = Pagination();
  int _nItems = 0;

  StreamSubscription subscription;
  void listenToItems() {
    // setBusy(true);

    subscription = _pagination
        .listenToItemsRealTime(query, modelConstructor)
        .listen((itemsData) {
      List<dynamic> updatedItems = itemsData;

      if (updatedItems != null && updatedItems.length > 0) {
        _items = updatedItems;
        notifyListeners();
      } else if (updatedItems.length == 0 && _nItems == 1) {
        _items = updatedItems;
        notifyListeners();
      }
      _nItems = updatedItems.length;

      // setBusy(false);
    });
  }

  void requestMoreData() {
    _pagination.requestItems(query, modelConstructor);
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
    _pagination.stopListening();
  }
}
