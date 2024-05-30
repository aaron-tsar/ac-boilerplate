import 'package:boilerplate/commons/mixin/app_mixin.dart';
import 'package:boilerplate/commons/mixin/auth_mixin.dart';
import 'package:boilerplate/commons/styles/styles.dart';
import 'package:boilerplate/commons/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatefulWidget {
  static const String path = '/UserScreen';

  const UserScreen({super.key});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> with AppMixin, AuthMixin {

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
      appBar: TitleAppBar(
        title: locale.profile,
      ),
      body: Text(
        "${currentProfile.username}",
        style: styles.blackTextColor.textTheme.textTitleStyle.copyWith(
          fontSize: 16,
        ),
      ),
    );
  }
}
