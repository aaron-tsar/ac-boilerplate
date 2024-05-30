import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../services/api_service/api_response/base_api_response.dart';
import '../mixin/app_mixin.dart';
import 'dart:math' show cos, sqrt, asin;

class AppUtils with AppMixin {
  static final AppUtils instance = AppUtils();

  T getCubit<T extends Cubit>(BuildContext context) => context.read<T>();

  DateTime parseDateFromServer(String date) => DateTime.parse(date).toLocal();

  String getErrorText(e) {
    String? error;
    if (e is ErrorResponse) {
      if(e.originalResponse != null) {
        error = e.message;
      }
    }
    return error ?? "Error";
  }
 static String formatVideoDuration(Duration position) {
    final ms = position.inMilliseconds;

    int seconds = ms ~/ 1000;
    final int hours = seconds ~/ 3600;
    seconds = seconds % 3600;
    final minutes = seconds ~/ 60;
    seconds = seconds % 60;

    final hoursString = hours >= 10
        ? '$hours'
        : hours == 0
        ? '00'
        : '0$hours';

    final minutesString = minutes >= 10
        ? '$minutes'
        : minutes == 0
        ? '00'
        : '0$minutes';

    final secondsString = seconds >= 10
        ? '$seconds'
        : seconds == 0
        ? '00'
        : '0$seconds';

    final formattedTime =
        '${hoursString == '00' ? '' : '$hoursString:'}$minutesString:$secondsString';

    return formattedTime;
  }

  String formatNumberCurrency(num? number) {
    final temp =
    number == null ? "-" : NumberFormat("#,##0.##", "en_US").format(number);
    return temp;
  }

  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  Future<bool> call(String? tel) async {
    if(tel == null || tel == "" || tel == "-") return false;
    final url = 'tel:${tel.startsWith('84') ? tel.replaceFirst('84', '') : tel}';
    if(!(await canLaunchUrlString(url))) return false;
    return launchUrlString(url);
  }

  Future<bool> openLocation(num? lat, num? lon) {
    return launchUrlString('https://www.google.com/maps/search/?api=1&query=$lat,$lon');
  }

  String getFirstAndLastDayOfMonth(String? inputDate) {
    try {
      DateTime date = DateTime.parse(inputDate.toString()).toLocal();

      DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);

      DateTime lastDayOfMonth = DateTime(date.year, date.month + 1, 0);
      return "${firstDayOfMonth.day.toString().padLeft(2, '0')}/${firstDayOfMonth.month.toString().padLeft(2, '0')}/${firstDayOfMonth.year} - ${lastDayOfMonth.day.toString().padLeft(2, '0')}/${lastDayOfMonth.month.toString().padLeft(2, '0')}/${lastDayOfMonth.year}";
    } catch (e) {
      return "-";
    }
  }
  DateTimeRange setDefaultDateTimeRange(){
    return DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 1)),
        end: DateTime.now());
  }

  static final DateFormat bookingDateFormat = DateFormat("yyyy-MM-dd");

}

extension ParseDurationToString on DateTime? {
  String? get hhmm => DateFormat("HH:mm").format(this!);
}

extension ParseNumberCurrency on String {
  String get cny => "$this ¥";
  String get vnd => "$this đ";
}