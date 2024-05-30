import 'package:boilerplate/commons/log/log.dart';
import 'package:boilerplate/services/date_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

class FireStoreCacheInterceptor extends InterceptorsWrapper {

  FireStoreCacheInterceptor() {
    init();
  }

  FirebaseFirestore get fireStore => FirebaseFirestore.instance;
  String get now => DateFormat(DateFormatConstants.ddMMYYYY).format(DateTime.now().toUtc());
  DocumentReference get entryCacheDoc => fireStore.collection("cache-switch").doc("document-switch");
  CollectionReference get cacheCollection => fireStore.collection("cache");
  DocumentReference getTargetDoc(Uri uri) => cacheCollection.doc(uri.toString().replaceAll("/", "-"));
  String get cacheDataKey => "data";
  String get requestCacheExtraKey => "mustCached";
  String get entryCacheParam => "day";

  void init() async {

    fireStore.runTransaction((transaction) async {
      final dayCheck = await transaction.get(entryCacheDoc);
      if(dayCheck.exists) {
        final currentDayCheck = dayCheck.data();
        if(currentDayCheck is Map && currentDayCheck[entryCacheParam] != now) {
          await removeAllCached();
          transaction.set(entryCacheDoc, {entryCacheParam: now});
        }
      }
    });
  }

  Future<void> removeAllCached() async {
    final batch = fireStore.batch();
    var snapshots = await cacheCollection.get();
    for (var doc in snapshots.docs) {
      batch.delete(doc.reference);
    }
    return batch.commit();
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final data = await fireStore.runTransaction((transaction) async {
      final dataCheck = await transaction.get(getTargetDoc(options.uri));
      if(dataCheck.exists) {
        DLog.info("Restore from FireStore ${dataCheck.data()}");
        return dataCheck.get(cacheDataKey);
      }
      return null;
    });

    if(data != null) {
      return handler.resolve(Response(
        requestOptions: options,
        statusCode: 200,
        extra: options.extra,
        data: data,
      ));
    }

    options.extra.addAll({
      requestCacheExtraKey: true,
    });
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if(response.statusCode == 200
        && response.data != null
        && response.requestOptions.extra[requestCacheExtraKey] == true) {
      DLog.info("Save to FireStore ${response.data}");
      fireStore.runTransaction((transaction) async {
        transaction.set(getTargetDoc(response.requestOptions.uri), {
          cacheDataKey: response.data,
        });
      });
    }
    super.onResponse(response, handler);
  }

}
