import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {

  FireStoreService._() {
    initCompleter.complete(this);
  }

  static FireStoreService? _instance;
  factory FireStoreService() => _instance ??= FireStoreService._();
  FirebaseFirestore get _fs => FirebaseFirestore.instance;

  Completer<FireStoreService> initCompleter = Completer();

}
