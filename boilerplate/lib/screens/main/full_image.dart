import 'package:boilerplate/commons/mixin/app_mixin.dart';
import 'package:boilerplate/commons/utils/app_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class FullImageScreen extends StatefulWidget {
  static String path = "/FullImageScreen";
  final AppImage args;

  const FullImageScreen({super.key, required this.args});

  @override
  _FullImageScreenState createState() => _FullImageScreenState();
}

class _FullImageScreenState extends State<FullImageScreen> with AppMixin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            color: Colors.black,
            child: widget.args.build(),
          ),
          Positioned(
            left: 32,
            top: 60,
            child: ElevatedButton(
              style: styles.buttonStyle.copyWith(
                shape: const WidgetStatePropertyAll(CircleBorder()),
                backgroundColor: WidgetStatePropertyAll(styles.whiteTextColor),
              ),
              onPressed: () {
                context.pop();
              },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  Icons.arrow_back_ios_sharp,
                  color: styles.blackTextColor,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
