import 'dart:io';

import 'package:boilerplate/constants/app_asset.dart';
import 'package:boilerplate/screens/main/full_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class AppImage {
  final String? path;

  const AppImage(this.path);

  bool get isSvg => path?.split('.').last == "svg";

  bool get isNetwork => path?.startsWith("http") == true;

  bool get isNull => path == null || path?.isEmpty == true;

  Widget network({
    double? memCacheWidth,
    double? memCacheHeight,
    String? cacheKey,
    Widget? placeHolder,
    Widget? error,
    Size? size,
    BoxFit fit = BoxFit.contain,
    Color? color,
  }) {
    ImageCache imageCache = PaintingBinding.instance.imageCache;
    if (imageCache.liveImageCount >= 100) {
      imageCache.clear();
      imageCache.clearLiveImages();
    }
    return RepaintBoundary(
      child: CachedNetworkImage(
        key: ValueKey(cacheKey),
        imageUrl: path!,
        fit: fit,
        height: size?.height,
        width: size?.width,
        filterQuality: FilterQuality.high,
        placeholder: placeHolder != null ? (context, _) => placeHolder : null,
        errorWidget: (context, url, error) => errorPlaceHolder(),
        color: color,
        cacheKey: cacheKey,
        memCacheHeight: _getCacheValue(memCacheHeight),
        memCacheWidth: _getCacheValue(memCacheWidth),
      ),
    );
  }

  Widget errorPlaceHolder({
    Size? size,
    BoxFit fit = BoxFit.contain,
  }){
    return SizedBox(
      height: size?.height,
      width: size?.width,
      child: LayoutBuilder(
        builder: (context, snapshot) {
          return Container(
            constraints: BoxConstraints(
              maxHeight: snapshot.maxHeight,
              maxWidth: snapshot.maxWidth,
            ),
            color: Colors.grey.withOpacity(0.3),
            child: FittedBox(
              child: Padding(
                padding: EdgeInsets.all(snapshot.maxHeight*0.1),
                child: AppAsset.logo.image.build(
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget asset({
    Size? size,
    BoxFit fit = BoxFit.contain,
    Color? color,
    Alignment? alignment,
    double? memCacheWidth,
    double? memCacheHeight,
    String? cacheKey,
  }) {
    return Image.asset(
      path!,
      color: color,
      height: size?.height,
      width: size?.width,
      fit: fit,
      alignment: alignment ?? Alignment.center,
      cacheHeight: _getCacheValue(memCacheHeight),
      cacheWidth: _getCacheValue(memCacheWidth),
    );
  }

  int? _getCacheValue(double? value) =>
      value?.isFinite == true && value! > 0 ? (value * 1).toInt() : null;

  Widget svgImg({
    Size? size,
    BoxFit fit = BoxFit.contain,
    Color? color,
  }) {
    if (path?.startsWith("http") == true) {
      return SvgPicture.network(
        path!,
        width: size?.width,
        height: size?.height,
        fit: fit,
        colorFilter:
        color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
      );
    }
    if (path != null) {
      return SvgPicture.asset(
        path!,
        width: size?.width,
        height: size?.height,
        fit: fit,
        colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
      );
    }
    return SizedBox(
      height: size?.height,
      width: size?.width,
    );
  }

  Widget build({
    Widget? placeHolder,
    Widget? error,
    Size? size,
    BoxFit fit = BoxFit.contain,
    Color? color,
    Alignment? alignment,
    double? memCacheWidth,
    double? memCacheHeight,
    String? cacheKey,
  }) {
    Widget? child;
    if (isNull) {
      return errorPlaceHolder(size: size);
    }
    if (isSvg) {
      child ??= svgImg(
        size: size,
        fit: fit,
        color: color,
      );
    }
    if (isNetwork) {
      child ??= network(
        memCacheHeight: memCacheHeight,
        memCacheWidth: memCacheWidth,
        cacheKey: cacheKey,
        placeHolder: placeHolder,
        error: error,
        size: size,
        fit: fit,
        color: color,
      );
    }
    final file = File(path ?? "");
    final isLocalFile = file.existsSync();
    if (isLocalFile) {
      child = Image.file(
        file,
        fit: fit,
        height: size?.height,
        width: size?.width,
        cacheHeight: _getCacheValue(memCacheHeight),
        cacheWidth: _getCacheValue(memCacheWidth),
      );
    }
    child ??= asset(
      size: size,
      fit: fit,
      color: color,
      alignment: alignment,
      cacheKey: cacheKey,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
    );
    return child;
  }
}

extension AppImageToFullScreen on AppImage {
  Widget buildWithFullScreen(BuildContext context, {
    Widget? placeHolder,
    Widget? error,
    Size? size,
    BoxFit fit = BoxFit.contain,
    Color? color,
    Alignment? alignment,
    double? memCacheWidth,
    double? memCacheHeight,
    String? cacheKey,
  }) {
    return GestureDetector(
      onTap: () {
        context.push(FullImageScreen.path, extra: this);
      },
      child: build(
        placeHolder: placeHolder,
        error: error,
        size: size,
        fit: fit,
        color: color,
        alignment: alignment,
        memCacheHeight: memCacheHeight,
        memCacheWidth: memCacheWidth,
        cacheKey: cacheKey,
      ),
    );
  }
}
