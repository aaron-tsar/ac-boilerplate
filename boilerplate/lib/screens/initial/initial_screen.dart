import 'package:flutter/material.dart';

import '../../commons/mixin/app_mixin.dart';

class InitialScreen extends StatefulWidget {

  static const String path = '/';

  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> with AppMixin {

  @override
  void initState() {
    appCubit.initMetaData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}

