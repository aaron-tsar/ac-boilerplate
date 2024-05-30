import 'package:badges/badges.dart' as badges;
import 'package:boilerplate/commons/mixin/app_mixin.dart';
import 'package:boilerplate/commons/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';

class AppMainBottomBar extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const AppMainBottomBar(this.navigationShell, {super.key});

  @override
  State<AppMainBottomBar> createState() => _AppMainBottomBarState();
}

class _AppMainBottomBarState extends State<AppMainBottomBar> with AppMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -1),
            blurRadius: 4,
            color: Color.fromRGBO(0, 0, 0, 0.1),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: getAppImage(HeroIcons.home, false),
            activeIcon: getAppImage(HeroIcons.home, true),
            label: locale.name,
          ),
          BottomNavigationBarItem(
            icon: getAppImage(HeroIcons.shoppingBag, false, showBadge: true),
            activeIcon: getAppImage(HeroIcons.shoppingBag, true, showBadge: true),
            label: "Giỏ hàng",
          ),
          BottomNavigationBarItem(
            icon: getAppImage(HeroIcons.bell, false),
            activeIcon: getAppImage(HeroIcons.bell, true),
            label: locale.notification,
          ),
          BottomNavigationBarItem(
            icon: getAppImage(HeroIcons.user, false),
            activeIcon: getAppImage(HeroIcons.user, true),
            label: locale.account,
          ),
        ],
        currentIndex: widget.navigationShell.currentIndex,
        onTap: (index) {
          widget.navigationShell.goBranch(
            index,
            initialLocation: index == widget.navigationShell.currentIndex,
          );
        },
      ),
    );
  }

  Widget getAppImage(HeroIcons asset, bool selected, {bool showBadge = false}){
    final child = HeroIcon(
      asset,
      size: 24,
      style: selected ? HeroIconStyle.solid : HeroIconStyle.outline,
      color: styles.light.bottomNavigationBarTheme.selectedItemColor,
    );
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          showBadge ? badges.Badge(
            position: badges.BadgePosition.topEnd(top: -10, end: -8),
            showBadge: true,
            ignorePointer: true,
            badgeContent: Text(
              "0",
              style: styles.whiteTextColor.textTheme.textStyle.copyWith(
                fontSize: 11,
              ),
            ),
            child: child,
          ) : child,
          const SizedBox(height: 8),
          Container(
            width: 14,
            height: 1.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: selected
                  ? styles.light.bottomNavigationBarTheme.selectedItemColor
                  : Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
