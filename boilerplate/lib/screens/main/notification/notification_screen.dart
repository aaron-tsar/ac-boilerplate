import 'package:boilerplate/commons/cubits/generic_list_cubit/generic_list_cubit.dart';
import 'package:boilerplate/commons/cubits/generic_list_cubit/generic_list_cubit_helper.dart';
import 'package:boilerplate/commons/enums/enums.dart';
import 'package:boilerplate/commons/mixin/app_mixin.dart';
import 'package:boilerplate/commons/mixin/auth_mixin.dart';
import 'package:boilerplate/commons/styles/styles.dart';
import 'package:boilerplate/commons/styles/themes/default_theme.dart';
import 'package:boilerplate/commons/widgets/app_bar.dart';
import 'package:boilerplate/commons/widgets/empty_widget.dart';
import 'package:boilerplate/commons/widgets/shimmers.dart';
import 'package:boilerplate/models/notification_model.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  static const String path = '/NotificationScreen';

  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with AppMixin, ListenComingNotification {
  NotificationTab filterPicked = NotificationTab.system;
  late GenericListCubit<NotificationModel> systemNotiCubit;
  late GenericListCubit<NotificationModel> customerNotiCubit;

  @override
  void initState() {

    systemNotiCubit = GenericListCubit(
      future: (page, limit) => appRepos.notiRepos.getSystemNotification(
        page: page,
        limit: limit,
      ).then((value) {
        authCubit.notificationController.applyStats(NotificationTab.system, value.$2);
        return value.$1;
      }),
      limit: 10,
    );
    customerNotiCubit = GenericListCubit(
      future: (page, limit) => appRepos.notiRepos.getCustomerNotification(
        page: page,
        limit: limit,
      ).then((value) {
        authCubit.notificationController.applyStats(NotificationTab.customer, value.$2);
        return value.$1;
      }),
      limit: 10,
    );
    systemNotiCubit.request();
    customerNotiCubit.request();

    systemNotiCubit.listenToState(
      onStateSuccess: (value) {

      },
      onStateError: (err) => showError(err?.message),
    );

    customerNotiCubit.listenToState(
      onStateSuccess: (value) {

      },
      onStateError: (err) => showError(err?.message),
    );

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    systemNotiCubit.close();
    customerNotiCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppBar(
        title: locale.notification,
      ),
      body: Column(
        children: [
          filter(),
          Expanded(
            child: IndexedStack(
              index: filterPicked == NotificationTab.system ? 0 : 1,
              children: [
                _listBody(systemNotiCubit),
                _listBody(customerNotiCubit),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _listBody(GenericListCubit<NotificationModel> cubit) {
    return RefreshIndicator(
      onRefresh: () async {
        cubit.refresh();
      },
      child: cubit.blocBuilder(
        builder: (context, state) {
          if(cubit.isLoadingInitial) {
            return const DefaultListingShimmer();
          }
          final list = state.value;

          if(list.isEmpty) {
            return const EmptyWidget(
              title: "Bạn không có thông báo mới",
            );
          }
          return MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              separatorBuilder: (context, index) {
                return Container(
                  height: 6,
                );
              },
              itemBuilder: (context, index) {
                final item = list[index];
                return Text(
                  "${item.content}",
                );
              },
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: list.length,
              controller: cubit.scrollController,
            ),
          );
        },
      ),
    );
  }

  Widget filter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8.0),
      child: Row(
        children: NotificationTab.values.map((e) {
          final picked = filterPicked == e;
          return Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: ElevatedButton(
              style: styles.buttonStyle.mergeBackgroundColor(picked ? null : Colors.transparent),
              onPressed: () {
                setState(() {
                  filterPicked = e;
                });
              },
              child: Text(
                e.title,
                style: (picked ? styles.greysTextColor.last : styles.blackTextColor).textTheme.boldStyle.copyWith(
                  fontSize: 13,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  void onComingNotification(NotificationModel? event) {
    if(event?.notiType == NotificationType.system) {
      systemNotiCubit.refresh();
    }
  }
}
