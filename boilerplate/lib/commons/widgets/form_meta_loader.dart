import 'dart:async';

import 'package:boilerplate/commons/mixin/app_mixin.dart';
import 'package:flutter/material.dart';


class FormDependLoader<T> extends StatefulWidget {
  final ValueNotifier<T> valueNotifier;
  final Function(T) builder;
  final Function(T)? onDependChanged;

  const FormDependLoader({
    super.key,
    required this.valueNotifier,
    required this.builder,
    this.onDependChanged
  });

  @override
  State<FormDependLoader<T>> createState() => _FormDependLoaderState<T>();
}

class _FormDependLoaderState<T> extends State<FormDependLoader<T>> with AppMixin{

  StreamSubscription<T>? _sub;
  T? currentVal;

  @override
  void initState() {
    currentVal = widget.valueNotifier.value;
    widget.valueNotifier.addListener(() {
      final value = widget.valueNotifier.value;
      if(value != currentVal) {
        currentVal = value;
        if(currentVal != null) widget.onDependChanged?.call(currentVal as T);
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder.call(currentVal as T);
  }
}