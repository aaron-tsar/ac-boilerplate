import 'package:boilerplate/services/date_services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:boilerplate/commons/validators/validator.dart';

extension EmptyNF on String {
  bool isStrictlyEmpty() {
    return trim().isEmpty;
  }
}

extension Empty on String? {
  bool isStrictlyEmpty() {
    return this == null || this!.trim().isEmpty;
  }
  bool get isImageURL=>Validator().isImageUrl(this??"");
}

extension Format on String {
  String dateFormat(
      {required DateTime dateTime,
      String format = DateFormatConstants.yyyyMMdd}) {
    final dateFormat = DateFormat(this).format(dateTime);
    return dateFormat;
  }

  String dateParse(
      {String format = DateFormatConstants.yyyyMMdd,
      bool isToLocal = false}) {
    final parsedDate = isToLocal
        ? DateTime.parse(this).toLocal()
        : DateTime.parse(this);
    final dateFormat = DateFormat(format).format(parsedDate);
    return dateFormat;
  }

  String addDuration(Duration duration,
      {String format = DateFormatConstants.yyyyMMdd}) {
    final parsedDate = DateTime.parse(this);
    final newDate = parsedDate.add(duration);
    final dateFormat = DateFormat(format).format(newDate);
    return dateFormat;
  }

  DateTime toDateTime() {
    final parsedDate = DateTime.parse(this);
    return parsedDate;
  }

  String getDiffTimeStamp({String format = DateFormatConstants.yyyyMMdd}) {
    final parsedDate = DateTime.parse(this);
    final dateFormat = DateFormat(format);

    final now = DateTime.now();
    final difference = now.difference(parsedDate);

    if (now.day == parsedDate.day) {
      if (difference.inHours < 1) {
        return "${difference.inMinutes}m ago";
      } else if (difference.inHours < 24) {
        return "${difference.inHours}h ago";
      }
    } else if (now.day != parsedDate.day) {
      return dateFormat.format(parsedDate);
    }
    return '';
  }
}

extension FormatNull on String? {
  String dateFormat(
      {required DateTime dateTime,
      String format = DateFormatConstants.yyyyMMdd}) {
    final dateFormat = DateFormat(format).format(dateTime);
    return dateFormat;
  }

  bool isReallyEmpty() {
    return this == null || this!.trim().isEmpty;
  }
}

extension StringToNumberNF on String {
  bool isAbleToConvertToNumber() =>
      Validator.instance.isAbleToConvertToNumber(trim());

  num? toNum() {
    ///convert failed
    if (!isAbleToConvertToNumber()) return null;

    ///Because maybe it may be has been formatted before
    ///So we need to remove all the comma symbol
    final textWithoutComma = replaceAll(",", "");
    final number = num.tryParse(textWithoutComma);
    return number;
  }
}

extension HexColor on String {
  int toHexCode() {
    final buffer = StringBuffer();
    if (length == 6 || length == 7) buffer.write('ff');
    buffer.write(replaceFirst('#', ''));
    return int.tryParse(buffer.toString(), radix: 16) ??
        Colors.white.value;
  }
}

extension HexColorNull on String? {
  int toHexCode() {
    if (this != null) {
      final buffer = StringBuffer();
      if (this!.length == 6 || this!.length == 7) buffer.write('ff');
      buffer.write(this!.replaceFirst('#', ''));
      return int.tryParse(buffer.toString(), radix: 16) ??
          Colors.white.value;
    }
    return Colors.white.value;
  }
}

extension StringToNumber on String? {
  bool isAbleToConvertToNumber() => this == null
      ? false
      : Validator.instance.isAbleToConvertToNumber(this!.trim());

  num? toNum() {
    ///convert failed
    if (!isAbleToConvertToNumber()) return null;

    ///Because maybe it may be has been formatted before
    ///So we need to remove all the comma symbol
    final textWithoutComma = this!.replaceAll(",", "");
    final number = num.tryParse(textWithoutComma);
    return number;
  }
}

extension E on String {
  String lastChars(int n) => substring(length - n);

  String get removeVietnameseDiacritics {
    final Map<String, String> diacriticsMap = {
      'à': 'a',
      'á': 'a',
      'ả': 'a',
      'ã': 'a',
      'ạ': 'a',
      'ă': 'a',
      'ằ': 'a',
      'ắ': 'a',
      'ẳ': 'a',
      'ẵ': 'a',
      'ặ': 'a',
      'â': 'a',
      'ầ': 'a',
      'ấ': 'a',
      'ẩ': 'a',
      'ẫ': 'a',
      'ậ': 'a',
      'è': 'e',
      'é': 'e',
      'ẻ': 'e',
      'ẽ': 'e',
      'ẹ': 'e',
      'ê': 'e',
      'ề': 'e',
      'ế': 'e',
      'ể': 'e',
      'ễ': 'e',
      'ệ': 'e',
      'ì': 'i',
      'í': 'i',
      'ỉ': 'i',
      'ĩ': 'i',
      'ị': 'i',
      'ò': 'o',
      'ó': 'o',
      'ỏ': 'o',
      'õ': 'o',
      'ọ': 'o',
      'ô': 'o',
      'ồ': 'o',
      'ố': 'o',
      'ổ': 'o',
      'ỗ': 'o',
      'ộ': 'o',
      'ơ': 'o',
      'ờ': 'o',
      'ớ': 'o',
      'ở': 'o',
      'ỡ': 'o',
      'ợ': 'o',
      'ù': 'u',
      'ú': 'u',
      'ủ': 'u',
      'ũ': 'u',
      'ụ': 'u',
      'ư': 'u',
      'ừ': 'u',
      'ứ': 'u',
      'ử': 'u',
      'ữ': 'u',
      'ự': 'u',
      'ỳ': 'y',
      'ý': 'y',
      'ỷ': 'y',
      'ỹ': 'y',
      'ỵ': 'y',
      'đ': 'd',
      'À': 'A',
      'Á': 'A',
      'Ả': 'A',
      'Ã': 'A',
      'Ạ': 'A',
      'Ă': 'A',
      'Ằ': 'A',
      'Ắ': 'A',
      'Ẳ': 'A',
      'Ẵ': 'A',
      'Ặ': 'A',
      'Â': 'A',
      'Ầ': 'A',
      'Ấ': 'A',
      'Ẩ': 'A',
      'Ẫ': 'A',
      'Ậ': 'A',
      'È': 'E',
      'É': 'E',
      'Ẻ': 'E',
      'Ẽ': 'E',
      'Ẹ': 'E',
      'Ê': 'E',
      'Ề': 'E',
      'Ế': 'E',
      'Ể': 'E',
      'Ễ': 'E',
      'Ệ': 'E',
      'Ì': 'I',
      'Í': 'I',
      'Ỉ': 'I',
      'Ĩ': 'I',
      'Ị': 'I',
      'Ò': 'O',
      'Ó': 'O',
      'Ỏ': 'O',
      'Õ': 'O',
      'Ọ': 'O',
      'Ô': 'O',
      'Ồ': 'O',
      'Ố': 'O',
      'Ổ': 'O',
      'Ỗ': 'O',
      'Ộ': 'O',
      'Ơ': 'O',
      'Ờ': 'O',
      'Ớ': 'O',
      'Ở': 'O',
      'Ỡ': 'O',
      'Ợ': 'O',
      'Ù': 'U',
      'Ú': 'U',
      'Ủ': 'U',
      'Ũ': 'U',
      'Ụ': 'U',
      'Ư': 'U',
      'Ừ': 'U',
      'Ứ': 'U',
      'Ử': 'U',
      'Ữ': 'U',
      'Ự': 'U',
      'Ỳ': 'Y',
      'Ý': 'Y',
      'Ỷ': 'Y',
      'Ỹ': 'Y',
      'Ỵ': 'Y',
      'Đ': 'D',
    };

    String result = '';
    for (final char in split('')) {
      final replacement = diacriticsMap[char];
      result += replacement ?? char;
    }

    return result;
  }
}
