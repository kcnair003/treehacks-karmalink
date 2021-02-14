import 'package:equatable/equatable.dart';

enum PaginationLifeCycle {
  loading,
  loaded,
}

class PaginationState<T> extends Equatable {
  final PaginationLifeCycle status;
  final List<T> items;

  PaginationState({
    this.status = PaginationLifeCycle.loading,
    this.items = const [],
  });

  PaginationState<T> copyWith({
    PaginationLifeCycle status,
    List<T> items,
  }) {
    return PaginationState(
      status: status ?? this.status,
      items: items ?? this.items,
    );
  }

  @override
  List<Object> get props => [status, items];

  @override
  String toString() => 'status: $status | items: $items';
}
