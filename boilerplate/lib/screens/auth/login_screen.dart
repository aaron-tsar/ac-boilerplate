import 'package:boilerplate/commons/cubits/generic_cubit/generic_cubit.dart';
import 'package:boilerplate/commons/cubits/generic_cubit/generic_cubit_helper.dart';
import 'package:boilerplate/commons/extensions/button.dart';
import 'package:boilerplate/commons/mixin/app_mixin.dart';
import 'package:boilerplate/commons/styles/styles.dart';
import 'package:boilerplate/commons/validators/validator.dart';
import 'package:boilerplate/commons/widgets/app_text_field.dart';
import 'package:boilerplate/constants/app_asset.dart';
import 'package:boilerplate/models/user.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const String path = '/LoginScreen';
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with AppMixin {
  late CustomTextEditingController usernameController;
  late CustomTextEditingController passwordController;
  late GenericCubit<User> loginCubit;
  late GenericCubit<User> socialLogin;

  @override
  void initState() {
    usernameController = CustomTextEditingController(text: "");
    passwordController = CustomTextEditingController(text: "");
    loginCubit = GenericCubit(() => appRepos.authRepos.login(usernameController.text, passwordController.text));
    loginCubit.listenToState(
      onStateError: (err) => showError(err?.message),
      onStateSuccess: (value) {
        authCubit.onLoggedIn(value);
      },
    );
    socialLogin = GenericCubit(() => appRepos.authRepos.login(usernameController.text, passwordController.text));
    socialLogin.listenToState(
      onStateError: (err) => showError(err?.message),
      onStateSuccess: (value) {
        authCubit.onLoggedIn(value);
      },
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppAsset.logo.image.build(
                size: const Size(50, 50),
              ),
              const SizedBox(height: 40),
              Text(
                locale.loginToYourAccount,
                style: styles.colorScheme.primary.textTheme.textTitleStyle.copyWith(
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              AppTextField(
                title: locale.login,
                controller: usernameController,
                focusedBorder: styles.defaultBorder,
                unfocusedBorder: styles.defaultBorder,
                hint: locale.login,
                validator: (value) => Validator.instance.isEmpty(value) ? "Tên đăng nhập không hợp lệ" : null,
              ),
              const SizedBox(height: 12),
              AppTextField(
                title: locale.password,
                controller: passwordController,
                focusedBorder: styles.defaultBorder,
                unfocusedBorder: styles.defaultBorder,
                hint: locale.password,
                validator: (value) => Validator.instance.isEmpty(value) ? "Mật khẩu không hợp lệ" : null,
                obscure: true,
              ),
              const SizedBox(height: 20),
              loginCubit.blocBuilder(
                builder: (context, snapshot) {
                  return ElevatedButton(
                    onPressed: () {
                      final res = usernameController.validate() == true
                          && passwordController.validate() == true;
                      if(res) loginCubit.getData();
                    },
                    child: Text(
                      locale.login,
                      style: styles.greysTextColor.last.textTheme.textTitleStyle.copyWith(
                        fontSize: 12,
                      ),
                    ),
                  ).buildLoadingButton(loginCubit.isLoadingState);
                }
              ),
              // Container(
              //   alignment: Alignment.center,
              //   padding: const EdgeInsets.symmetric(vertical: 12.0),
              //   child: Text(
              //     locale.or().toLowerCase(),
              //     style: styles.greysTextColor.first.textTheme.textTitleStyle.copyWith(
              //       fontSize: 12,
              //     ),
              //   ),
              // ),
              // OutlinedButton(
              //   style: styles.outlineButtonStyle.mergeOutlineColor(styles.defaultBorder.borderSide.color),
              //   onPressed: () {
              //     appRepos.authRepos.loginGoogle();
              //   },
              //   child: Row(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       AppAsset.google.image.build(),
              //       const SizedBox(width: 8),
              //       Text(
              //         locale.continueWithGoogle(),
              //         style: styles.greysTextColor[2].textTheme.subTitleStyle,
              //       ),
              //     ],
              //   ),
              // ),
              // const SizedBox(height: 12),
              // OutlinedButton(
              //   style: styles.outlineButtonStyle.mergeOutlineColor(styles.defaultBorder.borderSide.color),
              //   onPressed: () {
              //     appRepos.authRepos.loginFacebook();
              //   },
              //   child: Row(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       AppAsset.facebook.image.build(),
              //       const SizedBox(width: 8),
              //       Text(
              //         locale.continueWithFacebook(),
              //         style: styles.greysTextColor[2].textTheme.subTitleStyle,
              //       ),
              //     ],
              //   ),
              // ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    locale.dontHaveAccountYet,
                    style: styles.blackTextColor.textTheme.textStyle,
                  ),
                  const SizedBox(width: 4),
                  TextButton(
                    onPressed: () {
                      // context.pushReplacement(SignUpScreen.path);
                    },
                    child: Text(
                      locale.createOne,
                      style: styles.colorScheme.primary.textTheme.textStyle.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    locale.forgotYourPassword,
                    style: styles.blackTextColor.textTheme.textStyle,
                  ),
                  const SizedBox(width: 4),
                  TextButton(
                    onPressed: () {
                      // context.pushReplacement(ForgotPasswordScreen.path);
                    },
                    child: Text(
                      locale.resetIt,
                      style: styles.colorScheme.primary.textTheme.textStyle.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
