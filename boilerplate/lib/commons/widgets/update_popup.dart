import 'dart:async';
import 'dart:io';

import 'package:boilerplate/commons/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:boilerplate/commons/mixin/app_mixin.dart';
import 'package:boilerplate/commons/styles/styles.dart';
import 'package:boilerplate/flavor/flavor.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdatePopup extends StatelessWidget with AppMixin {
  final Completer removeUpdateOverlayCompleter;

  const UpdatePopup({super.key, required this.removeUpdateOverlayCompleter});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.75),
      alignment: Alignment.center,
      child: Dialog(
        backgroundColor: styles.greysTextColor.last,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(21),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "CSM ORD đã có phiên bản mới. Bạn có muốn cập nhật không?",
                style: styles.blackTextColor.textTheme.textStyle.copyWith(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 36),
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: (){
                          removeUpdateOverlayCompleter.complete();
                        },
                        child: Container(
                          height: double.infinity,
                          alignment: Alignment.center,
                          child: Text(
                            "Không",
                            style: AppColors.redPigment.textTheme.subTitleStyle.copyWith(
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: (){
                          removeUpdateOverlayCompleter.complete();
                          final appId = Platform.isAndroid
                              ? Flavor.instance.bundleId
                              : Flavor.instance.iosAppId;
                          final url = Uri.parse(
                            Platform.isAndroid
                                ? "https://play.google.com/store/apps/details?id=$appId"
                                : "https://apps.apple.com/app/id$appId",
                          );
                          launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        child: Text(
                          "Có",
                          style: styles.greysTextColor.last.textTheme.subTitleStyle.copyWith(
                            fontSize: 13,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
