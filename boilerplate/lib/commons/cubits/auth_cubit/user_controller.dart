import 'package:boilerplate/commons/cubits/app_cubit/app_cubit.dart';
import 'package:boilerplate/commons/log/log.dart';
import 'package:boilerplate/services/flutter_secure.dart';
import 'package:boilerplate/models/user.dart';
import 'package:flutter/material.dart';

class ProfileController {

  final AppCubit appCubit;

  final ValueNotifier<User> profileUpdateStream = ValueNotifier(User.getInit(init: true));

  ProfileController(this.appCubit);

  User get current => profileUpdateStream.value;

  Future getProfile() async {
    try {
      final profile = await appCubit.appReposProvider.authRepos
          .getProfile();

      if(profile != null) {
        _applyProfile(profile);
      }
    } on Exception catch(e) {
      DLog.error(e.toString());
    }
  }

  Future onUserUpdateStat() {
    return Future.wait<dynamic>([

    ]);
  }

  Future _applyProfile(User profile) async {
    profileUpdateStream.value = profile;
    return AppSecureStorage.saveProfile(profile);
  }

  Future setProfile(User profile) async {
    return _applyProfile(profile);
  }

  void onLogout() {
    profileUpdateStream.value = User.getInit(init: true);
  }
}

typedef WithStreamBuilderWidget<T> = Widget Function(T snapshot);

extension WithStreamBuilder on ProfileController {
  Widget buildDependWidget({required WithStreamBuilderWidget child}){
    return ValueListenableBuilder<User>(
      valueListenable: profileUpdateStream,
      builder: (context, snapshot, _) {
        return child.call(snapshot);
      },
    );
  }
}
