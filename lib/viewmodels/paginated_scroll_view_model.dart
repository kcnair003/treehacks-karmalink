import '../locator.dart';
import '../services/firestore_service.dart';
import 'base_model.dart';

class PaginatedScrollViewModel extends BaseModel {
  PaginatedScrollViewModel({this.type, this.uid});

  final ItemType type;
  final String uid;

  List<dynamic> _items = List<dynamic>();
  List<dynamic> get items => _items;

  final _firestoreService = locator<FirestoreService>();

  void listenToItems() {
    setBusy(true);

    _firestoreService.listenToItemsRealTime(uid, type).listen((itemsData) {
      List<dynamic> updatedItems = itemsData;
      print('items updated!');
      if (updatedItems != null && updatedItems.length > 0) {
        _items = updatedItems;
        notifyListeners();
      }

      setBusy(false);
    });
    print('listening complete');
  }

  void requestMoreData() => _firestoreService.requestMoreData(uid, type);
}
