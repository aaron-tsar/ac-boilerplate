import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:boilerplate/commons/cubits/app_cubit/app_cubit.dart';
import 'package:boilerplate/commons/cubits/auth_cubit/auth_cubit.dart';
import 'package:boilerplate/generated/codegen_loader.g.dart';
import 'package:boilerplate/localizations/app_localization.dart';
import 'package:boilerplate/routers/routers.dart';


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late AppCubit appCubit;
  late AuthCubit authCubit;

  @override
  void initState() {
    appCubit = AppCubit();
    authCubit = AuthCubit(appCubit);
    Routes.instance.applyWithAuthState(authCubit);
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: appCubit),
        BlocProvider.value(value: authCubit),
      ],
      child: BlocBuilder(
        bloc: appCubit,
        builder: (context, state) {

          return EasyLocalization(
            useOnlyLangCode: true,
            supportedLocales: SupportedLocale.values.map((e) => e.locale).toList(),
            path: SupportedLocale.assetLanguage,
            fallbackLocale: SupportedLocale.vi.locale,
            saveLocale: true,
            useFallbackTranslations: true,
            assetLoader: const CodegenLoader(),
            child: ScreenUtilInit(
              designSize: const Size(428, 989),
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (context, child) {
                return MaterialApp.router(
                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                  theme: appCubit.state.appStyle.light,
                  debugShowCheckedModeBanner: false,
                  locale: context.locale,
                  builder: (context, widget) {
                    final routeMounted = Routes.instance.routeMounted;
                    if(!routeMounted.isCompleted) routeMounted.complete(true);
                    return GestureDetector(
                      onTap: (){
                        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                      },
                      child: MediaQuery(
                        data: MediaQuery.of(context),
                        child: widget ?? const SizedBox(),
                      ),
                    );
                  },
                  routerConfig: Routes.instance.router,
                );
              },
            ),
          );
        }
      ),
    );
  }
}
