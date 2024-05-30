import 'package:boilerplate/commons/cubits/auth_cubit/user_controller.dart';
import 'package:boilerplate/commons/mixin/app_bar_mixin.dart';
import 'package:boilerplate/commons/mixin/app_mixin.dart';
import 'package:boilerplate/commons/mixin/auth_mixin.dart';
import 'package:boilerplate/commons/styles/styles.dart';
import 'package:boilerplate/commons/widgets/app_bar.dart';
import 'package:boilerplate/commons/widgets/user_avatar.dart';
import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget with AppMixin, AppBarMixin, AuthMixin {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      height: appBarHeight,
      child: _appBar(),
    );
  }

  @override
  double get appBarDesignHeight => 240;

  Widget _appBar(){
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          authCubit.profileController.buildDependWidget(
            child: (value) => Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${currentProfile.username}",
                        style: styles.whiteTextColor.textTheme.textTitleStyle.copyWith(
                          fontSize: 30,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${locale.name}!",
                        style: styles.whiteTextColor.textTheme.textStyle.copyWith(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 17),
                // TextButton(
                //   onPressed: () {
                //
                //   },
                //   child: HeroIcon(
                //     HeroIcons.bell,
                //     size: 21,
                //     style: HeroIconStyle.outline,
                //     color: styles.whiteTextColor,
                //   ),
                // ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: styles.whiteTextColor,
                borderRadius: BorderRadius.circular(100),
              ),
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const Flexible(
                    flex: 1,
                    child: ProfileAvatar(borderWidth: 10),
                  ),
                  divider(),

                  _section("Số dư", "0", () {

                  }),
                  divider(),
                  _section("Đơn hàng", "0", () {

                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(String title, String description, Function onClick){
    return Expanded(
      flex: 2,
      child: TextButton(
        onPressed: () => onClick(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: styles.blackTextColor.textTheme.textStyle.copyWith(
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: styles.blackTextColor.textTheme.subTitleStyle.copyWith(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget divider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: double.infinity,
      width: 1,
      color: styles.greysTextColor[3],
    );
  }
}