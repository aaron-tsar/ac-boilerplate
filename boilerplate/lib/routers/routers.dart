import 'dart:async';

import 'package:boilerplate/commons/cubits/auth_cubit/auth_cubit.dart';
import 'package:boilerplate/commons/enums/enums.dart';
import 'package:boilerplate/commons/styles/styles.dart';
import 'package:boilerplate/commons/utils/app_colors.dart';
import 'package:boilerplate/commons/utils/app_image.dart';
import 'package:boilerplate/commons/widgets/maintenance_popup.dart';
import 'package:boilerplate/commons/widgets/update_popup.dart';
import 'package:boilerplate/constants/app_asset.dart';
import 'package:boilerplate/generated/locale_keys.g.dart';
import 'package:boilerplate/screens/auth/login_screen.dart';
import 'package:boilerplate/screens/initial/initial_screen.dart';
import 'package:boilerplate/screens/main/full_image.dart';
import 'package:boilerplate/screens/main/home/home_screen.dart';
import 'package:boilerplate/screens/main/main_screen.dart';
import 'package:boilerplate/screens/main/notification/notification_screen.dart';
import 'package:boilerplate/screens/main/slip/cart_screen.dart';
import 'package:boilerplate/screens/main/user/user_screen.dart';
import 'package:boilerplate/services/remote_config_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class Routes extends NavigatorObserver {
  static Routes instance = Routes();
  Completer<bool> routeMounted = Completer();

  final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey();

  BuildContext get context => rootNavigatorKey.currentContext!;

  late final GoRouter router;

  void popUntil(String routeName) {
    Routes.instance.rootNavigatorKey.currentState?.popUntil((route) =>
        route.settings.name ==
        (routeName.startsWith("/") ? routeName : "/$routeName"));
  }

  void popUntilFirst() {
    Routes.instance.rootNavigatorKey.currentState
        ?.popUntil((route) => route.isFirst);
  }

  Routes() {
    router = GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: InitialScreen.path,
      errorBuilder: (context, state) {
        return const SizedBox();
      },
      routes: <RouteBase>[
        GoRoute(
          path: InitialScreen.path,
          builder: (context, state) => const InitialScreen(),
        ),
        GoRoute(
          path: LoginScreen.path,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: FullImageScreen.path,
          builder: (context, state) => FullImageScreen(args: state.extra as AppImage),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return MainScreen(navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: HomeScreen.path,
                  builder: (context, state) => const HomeScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: CartScreen.path,
                  builder: (context, state) => const CartScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: NotificationScreen.path,
                  builder: (context, state) => const NotificationScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: UserScreen.path,
                  builder: (context, state) => const UserScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  void applyWithAuthState(AuthCubit authCubit) {
    authCubit.stream.listen((event) async {
      await routeMounted.future;
      switch (event.type) {
        case AuthStateType.unAuthenticated:
          if(context.mounted) context.go(LoginScreen.path);
          break;
        case AuthStateType.authenticated:
          if(context.mounted) context.go(HomeScreen.path);
          break;
        default:
          break;
      }
    });
  }

  OverlayState? get _appOverlayState =>
      rootNavigatorKey.currentState?.overlay;

  AppStyle get styles => AppStyle.of(context);

  LocaleKeys get locale => LocaleKeys();

  OverlayEntry showLoadingOverlay() {
    OverlayEntry overlayEntry = OverlayEntry(builder: (context) {
      return Container(
        color: Colors.transparent,
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            // color: _styles.blackColor.withOpacity(0.7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Shimmer.fromColors(
            baseColor: AppColors.white,
            highlightColor: AppColors.white,
            child: AppAsset.logo.image.build(
              size: const Size(35, 35),
              // color: _styles.whiteColor,
            ),
          ),
        ),
      );
    });

    _appOverlayState?.insert(overlayEntry);
    return overlayEntry;
  }

  Future<void> showLoadingDepend(Future future) async {
    final overlay = showLoadingOverlay();

    try {
      await future;
    } catch (e) {
      debugPrint(e.toString());
    }
    overlay.remove();
  }

  Future<void> showMaintenanceAppDialog() async {
    final res = RemoteConfigService().maintenance;
    if(!res) return;

    final Completer removeUpdateOverlayCompleter = Completer();
    OverlayEntry overlayEntry = OverlayEntry(builder: (context) {
      return MaintenancePopup(
        removeUpdateOverlayCompleter: removeUpdateOverlayCompleter,
      );
    });
    _appOverlayState?.insert(overlayEntry);
    await removeUpdateOverlayCompleter.future;
    overlayEntry.remove();
  }

  Future<void> showUpdateAppDialog() async {
    final res = await RemoteConfigService().mustUpdate();
    if(!res) return;

    final Completer removeUpdateOverlayCompleter = Completer();
    OverlayEntry overlayEntry = OverlayEntry(builder: (context) {
      return UpdatePopup(
        removeUpdateOverlayCompleter: removeUpdateOverlayCompleter,
      );
    });
    _appOverlayState?.insert(overlayEntry);
    await removeUpdateOverlayCompleter.future;
    overlayEntry.remove();
  }
}
