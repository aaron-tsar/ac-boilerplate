import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:boilerplate/services/api_service/api_response/base_api_response.dart';

import 'generic_list_cubit.dart';
import 'generic_list_cubit_state.dart';

extension GenericListCubitHelper<T> on GenericListCubit<T> {

  void listenToState({
    Function(List<T>)? onStateSuccess,
    Function(ErrorResponse?)? onStateError,
    Function? onStateLoading,
  }){
    stream.listen((event) {
      switch(event.type) {
        case GenericListStateType.succeed: onStateSuccess?.call(state.value); return;
        case GenericListStateType.loading: onStateLoading?.call(); return;
        case GenericListStateType.error: onStateError?.call(state.errorResponse); return;
        default: return;
      }
    });
  }

  Widget blocBuilder({
    required BlocWidgetBuilder<GenericListState<T>> builder,
    BlocBuilderCondition<GenericListState<T>>? buildWhen,
  }){
    return BlocBuilder(
      bloc: this,
      builder: builder,
      buildWhen: buildWhen,
    );
  }
}
