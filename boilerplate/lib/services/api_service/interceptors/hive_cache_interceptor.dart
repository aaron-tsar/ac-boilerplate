import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:path_provider/path_provider.dart';
import 'package:boilerplate/flavor/flavor.dart';

class HiveCacheInterceptor {

  static Future<DioCacheInterceptor> init() async {
    final cacheDir = await getTemporaryDirectory();
    final cacheStore = HiveCacheStore(
      cacheDir.path,
      hiveBoxName: Flavor.instance.displayName,
    );
    final customCacheOptions = CacheOptions(
      store: cacheStore,
      policy: CachePolicy.forceCache,
      priority: CachePriority.high,
      maxStale: const Duration(minutes: 5),
      hitCacheOnErrorExcept: [401, 404],
      keyBuilder: (request) {
        return request.uri.toString();
      },
      allowPostMethod: false,
    );
    return DioCacheInterceptor(options: customCacheOptions);
  }
}
