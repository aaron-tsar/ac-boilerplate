import 'package:boilerplate/commons/cubits/app_cubit/app_cubit.dart';
import 'package:boilerplate/commons/cubits/auth_cubit/auth_state.dart';
import 'package:boilerplate/commons/log/log.dart';
import 'package:boilerplate/models/user.dart';
import 'package:boilerplate/services/firebase_analytics_service.dart';
import 'package:boilerplate/services/flutter_secure.dart';
import 'package:boilerplate/services/local_auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'notification_controller.dart';
import 'user_controller.dart';

class AuthCubit extends Cubit<AuthState> {

  final AppCubit appCubit;

  final ValueNotifier<bool> faceIdAcceptStream = ValueNotifier(false);
  late final ProfileController profileController;
  late final NotificationController notificationController;

  AuthCubit(this.appCubit) : super(InitialAuth()) {
    onAppStarted();
    profileController = ProfileController(appCubit);
    notificationController = NotificationController(appCubit);
  }

  User get _currentProfile => profileController.profileUpdateStream.value;


  void onAppStarted() async {

    /// checkpoint to get clear secure storage
    if(await AppSharedPreferences().get1stInstall()) {
      await AppSecureStorage.onLogOutClear();
      await AppSharedPreferences().save1stInstall();
    }

    final authToken = await AppSecureStorage.getStoredAuthToken();
    final profile = await AppSecureStorage.getStoredProfile();

    appCubit.initInterceptor(authToken, this);

    if(authToken != null && profile != null) {
      final reqAuth = await AppSecureStorage.getReqAuth();
      faceIdAcceptStream.value = reqAuth;
      await onAuthenticated(profile);
    } else {
      emit(UnAuthenticated());
    }
    FlutterNativeSplash.remove();
  }

  Future onAuthenticated(User user) async {
    await getLoggedInMetadata(user);
    emit(Authenticated(user));
    getAfterAuthStateEmitted();
  }

  void onLoggedIn(User user) async {
    faceIdAcceptStream.value = false;
    await onAuthenticated(user);
  }

  void toggleAuthWithFaceId(bool accepted) async {
    final curState = state;
    if(curState is Authenticated) {
      final res = await FlutterLocalAuth.instance.authenticate();
      if(res) {
        await AppSecureStorage.saveReqAuth(accepted);
        faceIdAcceptStream.value = accepted;
      }
    }
  }

  Future getAfterAuthStateEmitted(){
    return Future.wait([
      FirebaseAnalyticsService().resetUserDetail(profile: _currentProfile),
      profileController.onUserUpdateStat(),
    ]);
  }

  Future<bool> getLoggedInMetadata(User user) async {
    await profileController.setProfile(user);
    await Future.wait([
      profileController.getProfile(),
    ]);
    return true;
  }

  void onLogout({bool requestLogout = true}) async {
    emit(UnAuthenticated());
    profileController.onLogout();
    await AppSecureStorage.onLogOutClear();
    await AppSharedPreferences().onLogOutClear();
    if(requestLogout) await _requestLogout();
  }

  Future _requestLogout() async {
    if(state is! Authenticated) return;
    try {
      await appCubit.appReposProvider.authRepos.logout();
    } on Exception catch(e) {
      DLog.error(e.toString());
    }
  }
}
