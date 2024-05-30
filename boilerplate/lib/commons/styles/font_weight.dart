
import 'package:flutter/cupertino.dart';

enum AppFontWeight {
  thin(FontWeight.w100),
  extraLight(FontWeight.w200),
  light(FontWeight.w300),
  regular(FontWeight.w400),
  medium(FontWeight.w500),
  semiBold(FontWeight.w600),
  bold(FontWeight.w700),
  extraBold(FontWeight.w800),
  ultraBold(FontWeight.w900);

  const AppFontWeight(this.weight);
  final FontWeight weight;

  TextStyle get textStyle => TextStyle(fontWeight: weight);
}