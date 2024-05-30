import 'dart:async';

import 'package:boilerplate/commons/mixin/app_mixin.dart';
import 'package:boilerplate/commons/styles/styles.dart';
import 'package:boilerplate/constants/app_asset.dart';
import 'package:flutter/material.dart';

class MaintenancePopup extends StatelessWidget with AppMixin {
  final Completer removeUpdateOverlayCompleter;

  const MaintenancePopup({super.key, required this.removeUpdateOverlayCompleter});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppAsset.logo.image.build(
                size: const Size(240, 240),
              ),
              Text(
                "Chúng tôi đang thực hiện bảo trì hệ thống để nâng cấp, xin hãy trở lại sau.",
                style: styles.blackTextColor.textTheme.boldStyle.copyWith(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
