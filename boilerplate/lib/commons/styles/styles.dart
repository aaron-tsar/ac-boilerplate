import 'package:boilerplate/commons/cubits/app_cubit/app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/app_colors.dart';
import 'font_weight.dart';

abstract class AppStyle {

  ThemeData get light;
  ColorScheme get colorScheme;
  Color get blackTextColor;
  Color get whiteTextColor;
  List<Color> get greysTextColor;
  InputBorder get defaultBorder;
  InputBorder get errorBorder;
  BoxDecoration get searchContainer;

  ButtonStyle get textButtonStyle;
  ButtonStyle get buttonStyle;
  ButtonStyle get outlineButtonStyle;

  ButtonStyle get whiteButton;

  static AppStyle of(BuildContext context) {
    return BlocProvider.of<AppCubit>(context).state.appStyle;
  }
}

class AppTextTheme {
  final Color color;

  AppTextTheme(this.color);

  TextStyle get mainStyle => const TextStyle().merge(color.toTextStyle);

  TextStyle get textStyle => mainStyle.copyWith(fontWeight: AppFontWeight.regular.weight);

  TextStyle get boldStyle => mainStyle.copyWith(fontWeight: AppFontWeight.medium.weight);

  TextStyle get subTitleStyle =>
      mainStyle.copyWith(fontWeight: AppFontWeight.semiBold.weight);

  TextStyle get textTitleStyle => mainStyle.copyWith(fontWeight: AppFontWeight.bold.weight);
}

extension ToAppTextTheme on Color {
  AppTextTheme get textTheme => AppTextTheme(this);

  LinearGradient get gradientItemColor => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          withAlpha(50),
          withAlpha(0),
        ],
      );

  LinearGradient get darkerGradientItemColor => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          withAlpha(0),
          withAlpha(80),
        ],
      );
}