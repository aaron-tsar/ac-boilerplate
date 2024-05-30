import 'package:boilerplate/commons/extensions/date_time.dart';
import 'package:boilerplate/commons/styles/styles.dart';
import 'package:boilerplate/commons/widgets/app_bar.dart';
import 'package:boilerplate/models/notification_model.dart';
import 'package:boilerplate/services/date_services.dart';
import 'package:flutter/material.dart';

import '../../../commons/mixin/app_mixin.dart';

class NotificationDetailScreen extends StatefulWidget {
  static const String path = '/NotificationDetailScreen';

  final NotificationModel notificationModel;

  const NotificationDetailScreen({super.key, required this.notificationModel});

  @override
  _NotificationDetailScreenState createState() => _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> with AppMixin {

  NotificationModel get item => widget.notificationModel;

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
      appBar: TitleBackAppBar(title: "Thông báo"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${item.title}",
              style: styles.blackTextColor.textTheme.subTitleStyle.copyWith(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              DateFormatConstants.ddMMYYYYhhmm.parseDateTime(item.createdDate),
              style: styles.greysTextColor[2].textTheme.textStyle.copyWith(
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "${item.content}",
              style: styles.blackTextColor.textTheme.textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
