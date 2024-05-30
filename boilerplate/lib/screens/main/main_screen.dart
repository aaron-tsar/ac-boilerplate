import 'package:boilerplate/commons/mixin/app_mixin.dart';
import 'package:boilerplate/commons/widgets/main_bottom_bar.dart';
import 'package:boilerplate/services/firebase_messaging_services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatefulWidget with AppMixin {
  final StatefulNavigationShell navigationShell;

  const MainScreen(this.navigationShell, {super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with AppMixin {

  @override
  void initState() {

    FirebaseMessagingService.instance.fmsCompleter.completeAfter(true);
    FirebaseMessagingService.instance.onAppStartedWithNotification();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: AppMainBottomBar(widget.navigationShell),
    );
  }
}
