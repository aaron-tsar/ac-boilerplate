import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:boilerplate/services/api_service/api_response/base_api_response.dart';

import 'generic_list_cubit_state.dart';

typedef GenericListCubitInputFuture<T> = Future<List<T>> Function(int page, int limit);

class GenericListCubit<T> extends Cubit<GenericListState<T>> {
  GenericListCubit({
    required this.future,
    required this.limit,
  }) : super(GenericListState<T>(type: GenericListStateType.initial)) {
    scrollController.addListener(_onScroll);
  }

  final GenericListCubitInputFuture<T> future;
  final int limit;
  final ScrollController scrollController = ScrollController();

  bool get isLoadingInitial =>
      state.type == GenericListStateType.loading && state.value.isEmpty;

  bool get isLoadMoreItem =>
      state.type == GenericListStateType.loading && state.value.isNotEmpty;

  void refresh() async {
    emit(GenericListState<T>(type: GenericListStateType.initial));
    request();
  }

  void deepRefresh() async {
    try {
      emit(state.copyWith(
        type: GenericListStateType.loading,
        page: 0,
        hasReachedMax: false,
      ));
      final res = await future.call(state.page + 1, limit);
      res.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
        state.copyWith(
          type: GenericListStateType.succeed,
          value: res,
          hasReachedMax: false,
          page: state.page + 1,
        ),
      );
    } on ErrorResponse catch(e) {
      emit(
        state.copyWith(
          type: GenericListStateType.error,
          errorResponse: e,
        ),
      );
    } catch(e) {
      emit(
        state.copyWith(
          type: GenericListStateType.error,
          errorResponse: ErrorResponse.defaultError(
            statusMessage: e.toString(),
          ),
        ),
      );
    }
  }

  void request() async {
    if (state.hasReachedMax) return;
    try {
      if (state.type == GenericListStateType.initial) {
        emit(state.copyWith(
          type: GenericListStateType.loading,
        ));
        final res = await future.call(state.page, limit);
        return emit(
          state.copyWith(
            type: GenericListStateType.succeed,
            value: res,
            hasReachedMax: false,
            page: state.page,
          ),
        );
      }
      emit(state.copyWith(
        type: GenericListStateType.loading,
      ));
      final res = await future.call(state.page + 1, limit);
      res.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
        state.copyWith(
          type: GenericListStateType.succeed,
          value: List.of(state.value)..addAll(res),
          hasReachedMax: false,
          page: state.page + 1,
        ),
      );
    } on ErrorResponse catch(e) {
      emit(
        state.copyWith(
          type: GenericListStateType.error,
          errorResponse: e,
        ),
      );
    } catch(e) {
      emit(
        state.copyWith(
          type: GenericListStateType.error,
          errorResponse: ErrorResponse.defaultError(
            statusMessage: e.toString(),
          ),
        ),
      );
    }
  }

  @override
  void emit(GenericListState<T> state) {
    if(isClosed) return;
    super.emit(state);
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
  }

  void _onScroll() {
    if (_isBottom) {
      if(isLoadMoreItem) return;
      request();
    }
  }

  bool get _isBottom {
    if (!scrollController.hasClients) return false;
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void insert(T value) {
    emit(state.copyWith(
      type: GenericListStateType.succeed,
      value: List.of(state.value)..insert(0,value),

    ));
  }
}
