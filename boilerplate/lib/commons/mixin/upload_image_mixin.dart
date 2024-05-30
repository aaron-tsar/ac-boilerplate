
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:boilerplate/commons/utils/app_colors.dart';

mixin UploadImageMixin {
  Widget buildShimmerImage(
          {required Widget child,
          bool isLoading = false,
          VoidCallback? onUpload,
          bool isFailed = false}) =>
      Stack(
        alignment: Alignment.center,
        children: [
          child,
          if (isLoading || isFailed)
            Shimmer.fromColors(
              enabled: isLoading,
              baseColor: Colors.grey.withOpacity(.7),
              highlightColor: Colors.grey[100]!.withOpacity(.5),
              child: child,
            ),
          if (isFailed)
            IconButton(
              color: Colors.red,
                onPressed: () {
                  if (onUpload != null) {
                    onUpload();
                  }
                },
                icon: const Icon(
                  Icons.refresh_outlined,
                  color: AppColors.white,
                  size: 30,
                ))
        ],
      );

  Stack buildCloseIcon({Function(int index)? onRemove, required int index}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(8, 0, 0, 8),
          child: Icon(
            CupertinoIcons.clear_circled,
            size: 29,
            color: AppColors.white,
          ),
        ),
        GestureDetector(
            onTap: () {
              if (onRemove != null) {
                onRemove(index);
              }
            },
            behavior: HitTestBehavior.translucent,
            child: const Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 0, 8),
              child: Icon(
                CupertinoIcons.clear_circled_solid,
                size: 29,
                color: Colors.black,
              ),
            )),
      ],
    );
  }
}
