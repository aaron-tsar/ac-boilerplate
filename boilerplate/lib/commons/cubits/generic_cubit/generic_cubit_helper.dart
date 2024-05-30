import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:boilerplate/commons/cubits/generic_cubit/generic_cubit.dart';
import 'package:boilerplate/commons/cubits/generic_cubit/generic_cubit_state.dart';
import 'package:boilerplate/services/api_service/api_response/base_api_response.dart';
extension GenericCubitHelper<T> on GenericCubit<T> {

  void listenToState({
    Function(T)? onStateSuccess,
    Function(ErrorResponse?)? onStateError,
    Function? onStateLoading,
  }){
    stream.listen((event) {
      switch(event.type) {
        case GenericStateType.succeed: onStateSuccess?.call(state.value as T); return;
        case GenericStateType.loading: onStateLoading?.call(); return;
        case GenericStateType.error: onStateError?.call(state.errorMessage); return;
        default: return;
      }
    });
  }

  Widget blocBuilder({
    required BlocWidgetBuilder<GenericState<T>> builder,
    BlocBuilderCondition<GenericState<T>>? buildWhen,
  }){
    return BlocBuilder(
      bloc: this,
      builder: builder,
      buildWhen: buildWhen,
    );
  }
}

extension GenericNonNullCubitHelper<T> on GenericNonNullCubit<T> {

  void listenToState({
    Function(T)? onStateSuccess,
    Function(ErrorResponse?)? onStateError,
    Function? onStateLoading,
  }){
    stream.listen((event) {
      switch(event.type) {
        case GenericStateType.succeed: onStateSuccess?.call(state.value as T); return;
        case GenericStateType.loading: onStateLoading?.call(); return;
        case GenericStateType.error: onStateError?.call(state.errorMessage); return;
        default: return;
      }
    });
  }

  Widget blocBuilder({
    required BlocWidgetBuilder<GenericState<T>> builder,
    BlocBuilderCondition<GenericState<T>>? buildWhen,
  }){
    return BlocBuilder(
      bloc: this,
      builder: builder,
      buildWhen: buildWhen,
    );
  }
}
