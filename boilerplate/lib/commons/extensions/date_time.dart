import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

extension DateTimeExtension on DateTime {

  DateTimeRange getCurrentMonthStartEndDay() {
    final currentDate = DateTime.now();
    // Get the first day of the current month
    final firstDayOfCurrentMonth =
        DateTime(currentDate.year, currentDate.month, 1);

    // Calculate the last day of the current month
    final lastDayOfCurrentMonth =
        DateTime(currentDate.year, currentDate.month + 1, 0);
    return DateTimeRange(
        start: firstDayOfCurrentMonth, end: lastDayOfCurrentMonth);
  }

  DateTimeRange getOneYearRangeFromCurrent() {
    // Get the first day of the next month
    DateTime firstDayOfNextMonth = DateTime(year,  month + 1, 1);

    // Subtract one day from the first day of the next month to get the last day of the current month
    DateTime lastDayOfCurrentMonth = firstDayOfNextMonth.subtract
      (const Duration(seconds: 1));

    // // Get the first day of the current month
    // final endDayOfCurrentMonth = DateTime(year, month + 1, 30);

    // Start day of the current month one year ago
    final startDayOfCurrentMonthOneYearAgo =
        DateTime(year - 1, month, 1);

    return DateTimeRange(
        start: startDayOfCurrentMonthOneYearAgo,
        end: lastDayOfCurrentMonth);
  }

  DateTimeRange getCurrentMonthEndDayAndPreviousMonthEndDay() {
    final currentDate = DateTime.now();
    // Get the first day of the current month
    // End day of the current month
    final endDayOfCurrentMonth =
        DateTime(currentDate.year, currentDate.month + 1, 0);

    // Start day of the previous month
    final startDayOfPreviousMonth =
        DateTime(currentDate.year, currentDate.month - 1, 1);

    return DateTimeRange(
        start: startDayOfPreviousMonth, end: endDayOfCurrentMonth);
  }

  DateTime getPreviousMonth() {
    final startDayOfPreviousMonth = DateTime(year, month - 1, 1);
    return startDayOfPreviousMonth;
  }

}


extension FormatDate on String? {
  String parseDateTime(String? serverTime) => serverTime == null || this == null
      ? "-"
      : DateFormat(this).format(DateTime.parse(serverTime).toLocal());
}

extension FormatDateServer on DateFormat {
  String parseDateTime(String? serverTime) => serverTime == null
      ? "-"
      : format(DateTime.parse(serverTime).toLocal());

}
