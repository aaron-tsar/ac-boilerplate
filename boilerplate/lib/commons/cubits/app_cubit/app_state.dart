import 'package:boilerplate/commons/styles/styles.dart';
import '../../../../localizations/app_localization.dart';

enum AppStateType {initial, loaded}

class AppState {
  final AppStyle appStyle;
  final SupportedLocale supportedLocale;
  final AppStateType type;

  AppState({required this.appStyle, required this.supportedLocale, required this.type});

  @override
  bool operator ==(Object other) => other is AppState
      && other.hashCode == hashCode;

  @override
  int get hashCode => Object.hash(appStyle, supportedLocale);

  SupportedLocale get dLocale => SupportedLocale.vi;

  AppState copyWith({
    AppStyle? appStyle,
    SupportedLocale? supportedLocale,
    AppStateType? type,
  }) {
    return AppState(
      type: type ?? this.type,
      appStyle: appStyle ?? this.appStyle,
      supportedLocale: supportedLocale ?? this.supportedLocale,
    );
  }
}
