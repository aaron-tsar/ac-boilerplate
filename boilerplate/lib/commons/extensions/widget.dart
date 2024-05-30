import 'package:boilerplate/commons/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

extension WidgetLoadingExt on Widget {
  Widget buildLoadingWidget(bool loading, AppStyle styles) {
    return loading ? IgnorePointer(
      ignoring: true,
      child: Shimmer.fromColors(
        baseColor: styles.greysTextColor.last,
        highlightColor: styles.greysTextColor[3],
        child: this,
      ),
    ) : this;
  }
}