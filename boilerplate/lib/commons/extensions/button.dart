import 'package:boilerplate/commons/mixin/app_mixin.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ElevatedButtonLoading extends StatelessWidget with AppMixin {

  final bool loading;
  final VoidCallback? onPressed;
  final Widget? child;
  final ButtonStyle? initStyle;

  const ElevatedButtonLoading({super.key, required this.onPressed, required this.child, this.loading = false, this.initStyle});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if(loading) return;
        onPressed?.call();
      },
      style: loading ? ElevatedButton.styleFrom(
        backgroundColor: styles.greysTextColor[3],
        foregroundColor: styles.greysTextColor[2]
      ) : initStyle,
      child: loading ? Shimmer.fromColors(
        baseColor: styles.greysTextColor.last,
        highlightColor: styles.greysTextColor[3],
        child: child!,
      ) : child!,
    );
  }


}

class ElevatedButtonDisable extends StatelessWidget with AppMixin {

  final bool disable;
  final VoidCallback? onPressed;
  final Widget? child;
  final ButtonStyle? initStyle;

  const ElevatedButtonDisable({super.key, required this.onPressed, required this.child, this.disable = false, this.initStyle});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if(disable) return;
        onPressed?.call();
      },
      style: disable ? ElevatedButton.styleFrom(
        backgroundColor: styles.greysTextColor[3],
        foregroundColor: styles.greysTextColor[2],
      ) : null,
      child: child!,
    );
  }


}

extension ElevatedButtonLoadingExt on ElevatedButton {
  Widget buildLoadingButton(bool loading) {
    return ElevatedButtonLoading(
      onPressed: onPressed,
      loading: loading,
      initStyle: style,
      child: child,
    );
  }

  Widget buildDisableButton(bool disable) {
    return ElevatedButtonDisable(
      onPressed: onPressed,
      disable: disable,
      child: child,
    );
  }
}