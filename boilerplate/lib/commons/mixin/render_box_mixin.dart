import 'package:flutter/material.dart';

mixin RenderBoxMixin {
  Future<Offset?> getOffset(GlobalKey globalKey,
      {GlobalKey? ancestorKey}) async {
    final endFrame = WidgetsBinding.instance.endOfFrame;
    await endFrame;
    final box = globalKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      return box.localToGlobal(Offset.zero,
          ancestor:
              ancestorKey?.currentContext?.findRenderObject() as RenderBox?);
    }
    return null;
  }

  Future<RenderBox?> getRenderBox(GlobalKey globalKey) async {
    final endFrame = WidgetsBinding.instance.endOfFrame;
    await endFrame;
    return globalKey.currentContext?.findRenderObject() as RenderBox?;
  }

  RenderBox? getRenderBoxContext(BuildContext context) {
    return context.findRenderObject() as RenderBox?;
  }
}
