import 'package:boilerplate/commons/mixin/app_mixin.dart';
import 'package:boilerplate/commons/mixin/auth_mixin.dart';
import 'package:boilerplate/commons/widgets/main_app_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String path = '/HomeScreen';

  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AppMixin, AuthMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(),
      body: Center(
        child: Text(locale.home),
      ),
    );
  }
}
