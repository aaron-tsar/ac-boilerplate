import 'package:equatable/equatable.dart';

import '../../../services/api_service/api_response/base_api_response.dart';

enum GenericListStateType { loading, error, succeed, initial }

class GenericListState<T> extends Equatable {
  final GenericListStateType type;
  final List<T> value;
  final ErrorResponse? errorResponse;
  final bool hasReachedMax;
  final int page;

  const GenericListState({
    required this.type,
    this.value = const [],
    this.errorResponse,
    this.hasReachedMax = false,
    this.page = 1,
  });

  GenericListState<T> copyWith({
    GenericListStateType? type,
    List<T>? value,
    bool? hasReachedMax,
    ErrorResponse? errorResponse,
    int? page,
  }) {
    return GenericListState<T>(
      type: type ?? this.type,
      value: value ?? this.value,
      errorResponse: errorResponse ?? this.errorResponse,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
    );
  }

  @override
  String toString() {
    return '''GenericListState<$T> { type: $type, page: $page ,hasReachedMax: $hasReachedMax, list: ${value.length} }''';
  }

  @override
  List<Object> get props => [type, value, hasReachedMax];
}
