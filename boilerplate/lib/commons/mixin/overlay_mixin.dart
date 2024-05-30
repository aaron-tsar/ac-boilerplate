import 'package:flutter/material.dart';

mixin OverlayMixin<T extends StatefulWidget> on State<T> {
  OverlayEntry? _overlayEntry;

  OverlayEntry? get currentOverlayEntry => _overlayEntry;
  bool currentOverlayShow = false;

  void showOverlay(
      Widget child, {
        double? top = 0,
        double? bottom = 0,
        double? right = 0,
        double? left = 0,
        OverlayState? overlayState,
      }) {
    _display(
        Positioned(
            left: left, top: top, right: right, bottom: bottom, child: child),
        overlayState: overlayState);
  }

  _display(
      Widget child, {
        OverlayState? overlayState,
      }) {
    if (_overlayEntry != null) {
      _internalRemove();
    }
    _overlayEntry = OverlayEntry(
        builder: (BuildContext context) => child, maintainState: true);

    (overlayState ?? Overlay.of(context)).insert(_overlayEntry!);
    currentOverlayShow = true;
  }

  void showLinkOverlay(
      {required LayerLink layerLink,
        required Widget child,
        Offset offset = Offset.zero,
        double? width,
        double? height,
        double? top = 0,
        double? bottom = 0,
        double? right = 0,
        Alignment followerAnchor = Alignment.topLeft,
        double? left = 0}) {
    _display(
      Positioned(
        top: top,
        right: right,
        left: left,
        bottom: bottom,
        width: width,
        height: height,
        child: CompositedTransformFollower(
          link: layerLink,
          followerAnchor: followerAnchor,
          showWhenUnlinked: false,
          offset: offset,
          child: child,
        ),
      ),
    );
  }

  void removeOverlay() {
    if (_overlayEntry != null) {
      _internalRemove();
      currentOverlayShow = false;
    }
  }

  _internalRemove() {
    try {
      currentOverlayShow = false;
      _overlayEntry?.remove();
    } catch (_) {}
  }

  @override
  void dispose() {
    _internalRemove();
    super.dispose();
  }
}
