import 'package:boilerplate/commons/mixin/app_mixin.dart';
import 'package:boilerplate/commons/mixin/auth_mixin.dart';
import 'package:boilerplate/commons/widgets/app_bar.dart';
import 'package:boilerplate/commons/widgets/empty_widget.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  static const String path = '/CartScreen';

  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with AppMixin, AuthStateChanged {


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppBar(
        title: "Giỏ hàng",
      ),
      body: const EmptyWidget(title: "Giỏ hàng của bạn đang trống"),
    );
  }

  @override
  void onAuthStateChanged() {
    // TODO: implement onAuthStateChanged
  }
}
