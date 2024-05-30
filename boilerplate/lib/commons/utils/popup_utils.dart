import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:boilerplate/commons/styles/styles.dart';
import 'package:boilerplate/commons/utils/app_colors.dart';
import 'package:boilerplate/commons/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../mixin/app_mixin.dart';

enum FlushBarStatusType { succeed, error, info, warning }

class PopupUtils with AppMixin {
  BuildContext context;

  PopupUtils(this.context);

  Future showFlushBar({
    required String message,
    String? title,
    FlushBarStatusType flushBarStatusType = FlushBarStatusType.succeed,
    FlushbarPosition position = FlushbarPosition.TOP,
    Duration? duration,
    Function? onTap,
  }) {
    IconData icon;

    switch (flushBarStatusType) {
      case FlushBarStatusType.succeed:
        icon = Icons.check;
        title ??= "Hoàn tất";
        break;
      case FlushBarStatusType.error:
        icon = Icons.close;
        title ??= "Lỗi";
        break;
      case FlushBarStatusType.info:
        icon = Icons.info_outline;
        title ??= "Thông tin";
        break;
      case FlushBarStatusType.warning:
        icon = Icons.warning;
        title ??= "Thông báo";
        break;
    }
    Completer completer = Completer();
    double iconHeight = 15;
    final flush = Flushbar(
      boxShadows: kElevationToShadow[0],
      forwardAnimationCurve: Curves.decelerate,
      reverseAnimationCurve: Curves.easeOut,
      shouldIconPulse: false,
      onTap: (value) {
        onTap?.call();
      },
      backgroundColor: styles.greysTextColor.last,
      padding: const EdgeInsets.only(left: 18, top: 7, bottom: 11),
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: switch(flushBarStatusType) {
            FlushBarStatusType.succeed => AppColors.victorianGreenhouse,
            FlushBarStatusType.error => AppColors.redPigment,
            _ => styles.colorScheme.primary,
          },
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: iconHeight,
          color: styles.greysTextColor.last,
        ),
      ),
      borderRadius: BorderRadius.circular(10),
      borderColor: styles.colorScheme.primary,
      flushbarPosition: position,
      duration: duration ?? const Duration(seconds: 3),
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 3),
      messageText: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: styles.blackTextColor.textTheme.textTitleStyle,
          ),
          Text(
            message,
            style: styles.blackTextColor.textTheme.textStyle,
          ),
        ],
      ),
    );
    WidgetsBinding.instance.scheduleFrameCallback((timeStamp) {
      flush.show(context).then((value) {
        completer.complete();
      });
    });
    return completer.future;
  }

  static Future showModalBottom({
    required BuildContext context,
    required Widget child,
    required String title,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
          child: bottomSheetContainer(
            title,
            AppStyle.of(context),
            context,
            child,
          ),
        );
      },
    );
  }

  static Widget bottomSheetContainer(String title, AppStyle styles, BuildContext context, Widget child) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height/1.5,
      ),
      decoration: BoxDecoration(
        color: styles.whiteTextColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: styles.blackTextColor.textTheme.subTitleStyle.copyWith(
                      fontSize: 16,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 25,
                    color: styles.blackTextColor,
                  ),
                  onPressed: (){
                    context.pop();
                  },
                ),
              ],
            ),
          ),
          Flexible(child: child),
          SizedBox(height: MediaQuery.paddingOf(context).bottom),
        ],
      ),
    );
  }

  Future showConfirmDialog({
    required String content,
    Function? onPressYes,
    Function? onPressNo,
  }) {
    return showDialog(
      useRootNavigator: false,
      context: context,
      builder: (context) {
        return Dialog(
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
                  content,
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
                            context.pop();
                            onPressNo?.call();
                          },
                          child: Container(
                            height: double.infinity,
                            alignment: Alignment.center,
                            child: Text(
                              "Huỷ bỏ",
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
                            context.pop();
                            onPressYes?.call();
                          },
                          child: Text(
                            "Xác nhận",
                            style: styles.greysTextColor.last.textTheme.subTitleStyle.copyWith(
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future showAlertDialog({
    required String content,
    Function? onPress,
  }) {
    return showDialog(
      useRootNavigator: false,
      context: context,
      builder: (context) {
        return Dialog(
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
                  content,
                  style: styles.blackTextColor.textTheme.textStyle.copyWith(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 36),
                ElevatedButton(
                  onPressed: (){
                    context.pop();
                    onPress?.call();
                  },
                  child: Text(
                    "Xác nhận",
                    style: styles.greysTextColor.last.textTheme.subTitleStyle.copyWith(
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future showTextFieldDialog({
    required String content,
    Function(String)? onPressYes,
    TextInputType? textInputType,
    Function? onPressNo,
    String? init,
  }) {
    final CustomTextEditingController controller = CustomTextEditingController(text: init ?? "");
    return showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) {
        return Dialog(
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
                  content,
                  style: styles.blackTextColor.textTheme.textStyle.copyWith(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: controller,
                  focusedBorder: styles.defaultBorder,
                  unfocusedBorder: styles.defaultBorder,
                  textInputType: textInputType,
                ),
                const SizedBox(height: 36),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: (){
                            context.pop();
                            onPressNo?.call();
                          },
                          child: Container(
                            height: double.infinity,
                            alignment: Alignment.center,
                            child: Text(
                              "Huỷ bỏ",
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
                            context.pop();
                            onPressYes?.call(controller.text);
                          },
                          child: Text(
                            "Xác nhận",
                            style: styles.greysTextColor.last.textTheme.subTitleStyle.copyWith(
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) {
      controller.dispose();
      return value;
    });
  }
}
