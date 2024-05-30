import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:boilerplate/services/api_service/api_response/base_api_response.dart';
import 'generic_cubit_state.dart';

typedef GenericCubitInputFuture<T> = Future<T> Function();

class GenericCubit<T> extends Cubit<GenericState<T>> {
  GenericCubit(this.future) : super(GenericState<T>(type: GenericStateType.initial));

  final GenericCubitInputFuture<T?> future;

  bool get isLoadingState => state.type == GenericStateType.loading;

  bool get isErrorState => state.type == GenericStateType.error;

  bool get isSuccessState => state.type == GenericStateType.succeed;

  void getData() async {
    emit(GenericState<T>(type: GenericStateType.loading));
    try {
      final res = await future.call();
      if(res != null) {
        emit(GenericState<T>(type: GenericStateType.succeed, value: res));
      } else {
        emit(GenericState<T>(type: GenericStateType.error, errorMessage: ErrorResponse.defaultError()));
      }
    } on ErrorResponse catch(e) {
      emit(GenericState<T>(type: GenericStateType.error, errorMessage: e));
    } catch(e) {
      emit(GenericState<T>(type: GenericStateType.error, errorMessage: ErrorResponse.defaultError(
        statusMessage: e.toString(),
      )));
    }
  }

  @override
  void emit(GenericState<T> state) {
    if(isClosed) return;
    super.emit(state);
  }
}

class GenericNonNullCubit<T> extends Cubit<GenericState<T>> {
  GenericNonNullCubit(this.future) : super(GenericState<T>(type: GenericStateType.initial));

  final GenericCubitInputFuture<T> future;

  bool get isLoadingState => state.type == GenericStateType.loading;

  void getData() async {
    emit(GenericState<T>(type: GenericStateType.loading));
    try {
      final res = await future.call();
      if(res != null) {
        emit(GenericState<T>(type: GenericStateType.succeed, value: res));
      } else {
        emit(GenericState<T>(type: GenericStateType.error, errorMessage: ErrorResponse.defaultError()));
      }
    } on ErrorResponse catch(e) {
      emit(GenericState<T>(type: GenericStateType.error, errorMessage: e));
    } catch(e) {
      emit(GenericState<T>(type: GenericStateType.error, errorMessage: ErrorResponse.defaultError(
        statusMessage: e.toString(),
      )));
    }
  }

  @override
  void emit(GenericState<T> state) {
    if(isClosed) return;
    super.emit(state);
  }
}
