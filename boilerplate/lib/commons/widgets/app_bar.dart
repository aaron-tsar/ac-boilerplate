import 'package:boilerplate/commons/mixin/app_bar_mixin.dart';
import 'package:boilerplate/commons/mixin/app_mixin.dart';
import 'package:boilerplate/commons/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBarContainer extends StatelessWidget with AppMixin {
  final double height;
  final Widget child;

  const AppBarContainer({super.key, required this.height, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: styles.light.appBarTheme.backgroundColor,
        boxShadow: kElevationToShadow[1],
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(32),
          bottomLeft: Radius.circular(32),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
        child: child,
      ),
    );
  }
}

class TitleAppBar extends StatelessWidget with AppMixin, AppBarMixin {
  final String title;
  final Widget? leftWidget;
  final Widget? rightWidget;
  final double? percent;

  TitleAppBar({super.key, required this.title, this.leftWidget, this.rightWidget, this.percent});

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      height: appBarHeight,
      child: Opacity(
        opacity: (percent != null ? 1-percent! : null) ?? 1,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (leftWidget != null) Positioned(
                right: 0,
                child: leftWidget!),
            Text(
              title,
              style: styles.whiteTextColor.textTheme.subTitleStyle.copyWith(
                fontSize: 18,
              ),
            ),
            if (rightWidget != null) Positioned(
                right: 0,
                child: rightWidget!)
          ],
        ),
      ),
    );
  }

  @override
  double get appBarDesignHeight => 70;

}

class TitleBackAppBar extends StatelessWidget with AppMixin, AppBarMixin {
  final String title;
  final Widget? trailingWidgets;
  final double? percent;

  TitleBackAppBar({super.key, required this.title, this.trailingWidgets, this.percent});

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      height: appBarHeight,
      child: Opacity(
        opacity: (percent != null ? 1-percent! : null) ?? 1,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 0,
              child: IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: Icon(
                  Icons.arrow_back,
                  size: 22,
                  color: styles.whiteTextColor,
                ),
              ),
            ),
            Text(
              title,
              style: styles.whiteTextColor.textTheme.subTitleStyle.copyWith(
                fontSize: 18,
              ),
            ),
            if (trailingWidgets != null) Positioned(
                right: 0,
                child: trailingWidgets!)
          ],
        ),
      ),
    );
  }

  @override
  double get appBarDesignHeight => 70;

  static double designHeight = 70;
}

class AppSliverBar extends SliverPersistentHeaderDelegate with AppMixin {

  final String title;

  AppSliverBar(this.title);


  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final percent = shrinkOffset / maxExtent;
    return TitleBackAppBar(
      title: title,
      percent: percent,
    );
  }

  double get min => MediaQuery.paddingOf(appContext).top;

  @override
  // TODO: implement maxExtent
  double get maxExtent => min + TitleBackAppBar.designHeight;

  @override
  // TODO: implement minExtent
  double get minExtent => min;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

}