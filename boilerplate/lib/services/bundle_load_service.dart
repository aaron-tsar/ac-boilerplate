import 'dart:convert';
import 'dart:isolate';

import 'package:boilerplate/models/division.dart';
import 'package:flutter/services.dart';

class BundleLoadService {

  late VNDivision division;
  static BundleLoadService instance = BundleLoadService();

  Future<void> init() async {
    await rootBundle
        .loadString('assets/address/db.json')
        .then((jsonString) async {
      division = await Isolate.run<VNDivision>(() => VNDivision.fromJson(jsonDecode(jsonString)));
    });
  }
}