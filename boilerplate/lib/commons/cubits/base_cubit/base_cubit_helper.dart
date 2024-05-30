import 'package:boilerplate/commons/cubits/base_cubit/base_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension BaseCubitHelper<T> on BaseChangeCubit<T> {

  Widget blocBuilder({
    required BlocWidgetBuilder<BaseChangeState<T>> builder,
    BlocBuilderCondition<BaseChangeState<T>>? buildWhen,
  }){
    return BlocBuilder(
      bloc: this,
      builder: builder,
      buildWhen: buildWhen,
    );
  }
}
