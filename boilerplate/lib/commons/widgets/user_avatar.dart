import 'package:boilerplate/commons/mixin/app_mixin.dart';
import 'package:boilerplate/constants/app_asset.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget with AppMixin {
  final double? size;
  final double borderWidth;
  const ProfileAvatar({super.key, this.size, this.borderWidth = 1});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: styles.colorScheme.primary,
          width: borderWidth,
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: AppAsset.avatar.image.build(),
    );
  }
}
