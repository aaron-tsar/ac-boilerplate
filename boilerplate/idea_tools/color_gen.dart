import 'dart:convert';
import 'dart:developer';
import 'dart:io';

void main() async {
  try {
    var colors = await File('idea_tools/colors.json').readAsString();
    var mapColors = jsonDecode(colors);
    var dartFile = await File('idea_tools/app_colors').create(recursive: true);

    if(mapColors is Map) {

      String colorBlock = '';

      mapColors.forEach((key, value) {
        colorBlock = "$colorBlock\n   static const $key = Color(0xFF${value.toString().replaceAll("#", "")});";
        // colorBlock = "$colorBlock\n  $key(\"$value\"),";
      });

      dartFile.writeAsString(getAppColorsValues(colorBlock));
    }

  } on Exception catch (e) {
    log(e.toString());
  }
}

String getAppColorsValues(String colorBlock) => '''
import 'package:flutter/cupertino.dart';

class AppColors {

  $colorBlock
  
}
''';
//
// String getAppColorsValues(String colorBlock) => '''
// import 'package:flutter/cupertino.dart';
//
// enum AppColors {
//
//   $colorBlock
//
//   ;
//
//   const AppColors(this.code);
//   final String code;
//
//   Color get color => Color(0xFF\${code.replaceAll("#", "")});
// }
//
// extension ToTextStyle on Color {
//   TextStyle get toTextStyle => TextStyle(color: this);
// }
//
//
// ''';
