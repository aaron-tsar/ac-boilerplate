import 'package:flutter/material.dart';

enum SupportedLocale {
  vi,
  en,
  ja,
  ;

  Locale get locale => Locale(name);
  static const String assetLanguage = "assets/translations";
}


SupportedLocale find(Locale locale) {
  return SupportedLocale.values
      .firstWhere((element) => element.locale == locale);
}