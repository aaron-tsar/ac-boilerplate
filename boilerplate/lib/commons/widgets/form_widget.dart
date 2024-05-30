import 'package:boilerplate/commons/mixin/app_mixin.dart';
import 'package:boilerplate/commons/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class AppFormController {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  BehaviorSubject<Cubit?> subFormCubitStream = BehaviorSubject();

  bool? validate(){
    return key.currentState?.validate();
  }

  void dispose() {
    subFormCubitStream.close();
  }
}

class AppFormTitleField extends StatelessWidget with AppMixin {
  final String? title;
  const AppFormTitleField({super.key, this.title});
  bool get hasTitle => title != null;

  @override
  Widget build(BuildContext context) {
    if(hasTitle) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
        child: Text(
          title!,
          style: styles.blackTextColor.textTheme.boldStyle.copyWith(
            fontSize: 16,
          ),
        ),
      );
    }
    return const SizedBox();
  }
}

class AppFormTitle extends StatelessWidget with AppMixin {
  final String title;
  const AppFormTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
      child: Text(
        title,
        style: styles.blackTextColor.textTheme.subTitleStyle.copyWith(
          fontSize: 22,
        ),
      ),
    );
  }
}
