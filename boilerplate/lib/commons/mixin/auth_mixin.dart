import 'dart:async';

import 'package:boilerplate/commons/cubits/auth_cubit/auth_cubit.dart';
import 'package:boilerplate/models/notification_model.dart';
import 'package:boilerplate/models/user.dart';
import 'package:boilerplate/routers/routers.dart';
import 'package:boilerplate/services/firebase_messaging_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin AuthMixin {
  AuthCubit get _authCubit => BlocProvider.of<AuthCubit>(_appContext);
  BuildContext get _appContext => Routes.instance.context;

  User get currentProfile => _authCubit.profileController.current;

}

mixin AuthStateChanged<T extends StatefulWidget> on State<T> {
  StreamSubscription? _sub;

  @override
  void initState() {
    _sub = BlocProvider.of<AuthCubit>(Routes.instance.context).stream.listen((event) {
      onAuthStateChanged();
    });
    super.initState();
  }

  void onAuthStateChanged();

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

mixin ListenComingNotification<T extends StatefulWidget> on State<T> {
  StreamSubscription? _sub;

  @override
  void initState() {
    _sub = FirebaseMessagingService.instance.comingNotificationListener.listen(onComingNotification);
    super.initState();
  }

  void onComingNotification(NotificationModel? event);

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}