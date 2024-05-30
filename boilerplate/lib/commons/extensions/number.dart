import 'package:easy_localization/easy_localization.dart';
import 'package:boilerplate/commons/extensions/string.dart';

extension FormatNumber on num {
  ///[keepDecimalDigitLikeOrigin] set to true if you want to keep all the rest of digits numbers value

  ///[restNumberAfterComma]
  ///Get number length after comma
  ///EX: if set restNumberAfterComma is 2, 13,444=>13,44

  ///[floorWhenTheRestNumberIs]
  ///if floorWhenTheRestNumberIs is 99
  ///Ex: 14099 % 1000 =99 and 99 <= floorWhenTheRestNumberIs =>> 14099 -> 1400
  String formatNumber(
      {int decimalDigits = 0,
        int? restNumberAfterComma,
        bool keepDecimalDigitLikeOrigin = false,
        num? floorWhenTheRestNumberIs}) {
    String suffix = List.generate(decimalDigits, (index) => "0").join();
    num value = this;
    if (floorWhenTheRestNumberIs != null) {
      final theRestIs = value.getTheRestAfter(int.tryParse(
          "1${List.generate(value.toString().length - 2, (index) => 0).join()}") ??
          0);

      if (theRestIs <= floorWhenTheRestNumberIs) {
        value -= theRestIs;
      }
    }
    final splitText = toString().split(".");
    if (value == 0) {
      if (decimalDigits == 0) return "0";
      return "0.$suffix";
    } else if (splitText.first == "0") {
      suffix = List.generate(decimalDigits, (index) => "#").join();
    }
    if (keepDecimalDigitLikeOrigin) {
      final haveDecimalDigits = splitText.length > 1;
      if (haveDecimalDigits) {
        suffix = List.generate(splitText.last.length, (index) => "#").join();
      }
    }
    late String result;
    if (suffix.isNotEmpty) {
      result = NumberFormat('#,###.$suffix').format(value);
    } else {
      result = NumberFormat('#,###').format(value);
    }
    final haveDot = result.contains(".");
    if (!haveDot && suffix.isNotEmpty) {
      result =
      "$result.${List.generate(suffix.length, (index) => "0").join("")}";
    }
    if (restNumberAfterComma != null) {
      final reg = RegExp(r",+[\d,.]+");
      result = result.splitMapJoin(reg,
          onNonMatch: (m) => m,
          onMatch: (m) {
            List<String>? rawComma = m.group(0)?.split(",").toSet().toList();

            if (rawComma?.isNotEmpty == true) {
              if (rawComma!.first == "") {
                final Iterable<String> formatData =
                    rawComma.sublist(1).join().split("").reversed;
                List<String> removedZeroAtTheEnd = [];
                bool foundTheLimit = false;
                for (final e in formatData) {
                  if (e != "0") {
                    foundTheLimit = true;
                  }
                  if (foundTheLimit) {
                    removedZeroAtTheEnd.insert(0, e);
                  }
                }
                String result =
                removedZeroAtTheEnd.take(restNumberAfterComma).join();
                return [result.trim().isEmpty ? "" : ",", result].join().trim();
              }
            }
            return m.group(0) ?? "";
          });
    }
    return result;
  }


  num getTheRestAfter(num value) {
    return this % value;
  }

}
extension N on num {
  String esConvert({String? content}) {
    final List<String> specLastChar = ["sh", "s", "o", "ch", "z"];

    if (content != null && content.isNotEmpty) {
      if (this <= 1 || content.length < 2) return "$this $content";

      String sEs = "";

      if (specLastChar.contains(content.lastChars(2))) {
        sEs = "es";
      } else {
        sEs = "s";
      }
      return "$this $content$sEs";
    }
    return "";
  }

}
