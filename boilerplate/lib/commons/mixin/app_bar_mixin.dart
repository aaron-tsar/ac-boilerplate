import 'package:boilerplate/routers/routers.dart';
import 'package:flutter/cupertino.dart';

mixin AppBarMixin implements PreferredSizeWidget {
  double get appBarHeight =>
      appBarDesignHeight + MediaQuery.paddingOf(_appContext).top;

  double get appBarDesignHeight;

  BuildContext get _appContext => Routes.instance.context;

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);
}