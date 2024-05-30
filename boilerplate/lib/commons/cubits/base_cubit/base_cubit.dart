import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BaseChangeState<T> with EquatableMixin {
  final T? value;
  final String? uniqueId;

  BaseChangeState.init({this.value, this.uniqueId});
  BaseChangeState({this.value, this.uniqueId});

  @override
  List<Object?> get props => [uniqueId, value];
}

class BaseChangeCubit<T> extends Cubit<BaseChangeState<T>> {
  BaseChangeCubit() : super(BaseChangeState.init());

  void updateState(T? value) {
    emit(BaseChangeState(
      value: value,
      uniqueId: "${DateTime.now().microsecondsSinceEpoch}",
    ));
  }
}

