import 'package:boilerplate/commons/mixin/app_mixin.dart';
import 'package:boilerplate/commons/styles/styles.dart';
import 'package:boilerplate/constants/app_asset.dart';
import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget with AppMixin {
  final String? title;
  final Function? onRefresh;
  const EmptyWidget({super.key, required this.title, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: AppAsset.logo.image.build(
              color: Colors.grey,
              size: const Size(60, 60)
            ),
          ),
          if(title != null) Text(
            title!,
            style: Colors.grey.textTheme.boldStyle.copyWith(
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          if(onRefresh != null) Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: TextButton(
              onPressed: () {
                onRefresh!();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.refresh,
                    size: 14,
                    color: Colors.lightBlueAccent,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "Refresh",
                    style: Colors.lightBlueAccent.textTheme.boldStyle.copyWith(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
