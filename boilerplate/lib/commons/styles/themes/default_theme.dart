import 'package:boilerplate/commons/styles/styles.dart';
import 'package:boilerplate/commons/utils/app_colors.dart';
import 'package:flutter/material.dart';

class DefaultTheme extends AppStyle {
  @override
  // TODO: implement colorScheme
  ColorScheme get colorScheme => const ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.sonicBlue,
    onPrimary: AppColors.emperorJade,
    secondary: AppColors.burningTrail,
    onSecondary: AppColors.peachesLaCrMe,
    error: AppColors.redPigment,
    onError: AppColors.redPigment,
    surface: AppColors.white,
    onSurface: AppColors.lynxWhite,
  );

  @override
  InputBorder get defaultBorder => OutlineInputBorder(
    borderSide: BorderSide(
      width: 1,
      color: greysTextColor[1],
    ),
    borderRadius: BorderRadius.circular(9),
  );

  @override
  InputBorder get errorBorder => OutlineInputBorder(
    borderSide: const BorderSide(
      width: 1,
      color: AppColors.redPigment,
    ),
    borderRadius: BorderRadius.circular(9),
  );

  @override
  // TODO: implement searchContainer
  BoxDecoration get searchContainer => BoxDecoration(
    color: greysTextColor.last,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(
      color: greysTextColor[3],
      width: 1,
    ),
  );

  @override
  // TODO: implement light
  ThemeData get light => ThemeData(
    brightness: Brightness.light,
    colorScheme: colorScheme,
    unselectedWidgetColor: AppColors.tangledWeb,
    scaffoldBackgroundColor: AppColors.lynxWhite,
    fontFamily: 'Montserrat',
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.antarcticDeep,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      backgroundColor: colorScheme.primary,
      selectedItemColor: whiteTextColor,
      unselectedItemColor: AppColors.grey,
      selectedLabelStyle: TextStyle(
        fontSize: 11,
        color: colorScheme.secondary,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 11,
        color: AppColors.grey,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: textButtonStyle,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: buttonStyle,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: outlineButtonStyle,
    ),
    inputDecorationTheme: InputDecorationTheme(
      // isDense: true,
      // isCollapsed: true,
      // contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16).add(EdgeInsets.only(top: 4)),
      hintStyle: greysTextColor[0].textTheme.textStyle.copyWith(
        fontSize: 13,
      ),
    ),
    appBarTheme: AppBarTheme(
      color: colorScheme.primary,
    ),
  );

  @override
  // TODO: implement blackTextColor
  Color get blackTextColor => AppColors.black;

  @override
  // TODO: implement whiteTextColor
  Color get whiteTextColor => AppColors.white;

  @override
  // TODO: implement greysTextColor
  List<Color> get greysTextColor => [
    AppColors.millionGrey, //900
    AppColors.argent, //800
    AppColors.doveGrey, //6c
    AppColors.extraordinaryAbundanceOfTinge, //100
    AppColors.whiteOut, //50
  ];

  @override
  // TODO: implement buttonStyle
  ButtonStyle get buttonStyle => ButtonStyle(
    backgroundColor: WidgetStateProperty.all(colorScheme.secondary),
    elevation: WidgetStateProperty.all(0),
    minimumSize: WidgetStateProperty.all(Size.zero),
    padding: WidgetStateProperty.all(const EdgeInsets.all(10)),
    shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
    overlayColor: WidgetStatePropertyAll(AppColors.cascadingWhite.withOpacity(0.2)),
  );

  @override
  // TODO: implement outlineButtonStyle
  ButtonStyle get outlineButtonStyle => ButtonStyle(
    backgroundColor: WidgetStateProperty.all(AppColors.white),
    elevation: WidgetStateProperty.all(0),
    minimumSize: WidgetStateProperty.all(Size.zero),
    padding: WidgetStateProperty.all(const EdgeInsets.all(10)),
    shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
    side: WidgetStateProperty.all(BorderSide(
      color: colorScheme.primary, // your color here
      width: 1,
    )),
  );

  @override
  // TODO: implement textButtonStyle
  ButtonStyle get textButtonStyle => ButtonStyle(
    minimumSize: WidgetStateProperty.all(Size.zero),
    padding: WidgetStateProperty.all(EdgeInsets.zero),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );

  @override
  // TODO: implement whiteButton
  ButtonStyle get whiteButton => buttonStyle.mergeBackgroundColor(
    Colors.white,
  ).copyWith(
    overlayColor: WidgetStatePropertyAll(AppColors.grey.withOpacity(0.1)),
  );


}

extension ButtonStyleExtension on ButtonStyle {
  ButtonStyle mergeBackgroundColor(Color? color) => color == null ? this : copyWith(
    backgroundColor: WidgetStateProperty.all(color),
    // overlayColor: WidgetStateProperty.all(color)
  );
  ButtonStyle mergeOutlineColor(Color? color) => color == null ? this : copyWith(side: WidgetStateProperty.all(BorderSide(
    color: color, // your color here
    width: 1,
  )));
}