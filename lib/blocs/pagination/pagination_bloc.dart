import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:treehacks2021/services/src/pagination.dart';
import '../../models/models.dart';

import 'pagination_state.dart';

class PaginationCubit<T> extends Cubit<PaginationState<T>> {
  PaginationCubit(
    this.query,
    this.modelConstructor,
    this.mockItems,
  ) : super(PaginationState()) {
    emit(state.copyWith(
      status: PaginationLifeCycle.loaded,
      items: mockItems,
    ));
    // _paginationService.reset();
    // requestItems();
  }

  final Query query;
  final ModelConstructor<T> modelConstructor;

  // Testing purposes only
  final List<T> mockItems;

  Pagination _paginationService = Pagination();

  Future<void> requestItems() async {
    List<T> requestedItems =
        await _paginationService.requestItems<T>(query, modelConstructor);
    emit(state.copyWith(
      status: PaginationLifeCycle.loaded,
      items: List.from(state.items)..addAll(requestedItems),
    ));
  }

  void removeItemFromCache(T myItem) {
    emit(state.copyWith(
      items: List.from(state.items)..remove(myItem),
    ));
  }
}
