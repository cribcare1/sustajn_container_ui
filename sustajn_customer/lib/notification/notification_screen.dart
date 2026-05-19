import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_customer/common_widgets/custom_app_bar.dart';
import 'package:sustajn_customer/common_widgets/custom_back_button.dart';
import '../../constants/number_constants.dart';
import '../../utils/theme_utils.dart';
import '../constants/string_utils.dart';
import '../network_provider/network_provider.dart';
import '../utils/utils.dart';
import '../widgets/card_widget.dart';
import '../widgets/no_data_custom_text.dart';
import 'models/notice_model.dart';
import 'notification_dialog.dart';
import 'notification_notifier.dart';
import 'notification_provider.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationProvider).setContext(context);
      _getNotificationNetworkCall();
    });
    super.initState();
  }

  _getNotificationNetworkCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
          isNetworkAvailable,
          ) {
        final notificationState = ref.read(notificationProvider);
        if (isNetworkAvailable) {
          notificationState.setLoading(true);
          final userId = Utils.userId;
          ref.read(getNotification(userId ?? 0));
        } else {
          notificationState.setLoading(false);
          Utils.showToast(Strings.NO_INTERNET_CONNECTION);
        }
      });
    } catch (e) {
      Utils.printLog('Error in visitor button onPressed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final notificationState = ref.watch(notificationProvider);
    return Scaffold(
      appBar: CustomAppBar(
        title: Strings.NOTIFICATION,
        leading: CustomBackButton(),
        action: [
          //todo
          // TextButton(
          //   onPressed: () {},
          //   child: Text(
          //     Strings.MARK_ALL_READ,
          //     style: theme.textTheme.titleSmall!.copyWith(
          //       color: Constant.gold,
          //       decoration: TextDecoration.underline,
          //       decorationColor: Constant.gold,
          //       decorationThickness: 1.5,
          //     ),
          //   ),
          // ),
        ],
      ).getAppBar(context),
      body: notificationState.isLoading
          ? Center(child: CircularProgressIndicator())
          : notificationState.notificationList.length>0?ListView.separated(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
        itemCount: notificationState.notificationList.length,
        itemBuilder: (context, index) =>
            _notificationCard(notificationState.notificationList[index]),
        separatorBuilder: (context, index) =>
            SizedBox(height: Constant.CONTAINER_SIZE_10),
      ):Center(
          child: NoDataFoundCustomText(
            text: Strings.NO_NOTIFICATIONS,
          )
      ),
    );
  }

  _notificationCard(NotificationModel data) {
    return GlassSummaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              // Container(
              //   decoration: BoxDecoration(
              //     shape: BoxShape.circle,
              //     color: data.color,
              //   ),
              //   padding: EdgeInsets.all(3),
              //   child: Icon(data.icon, size: 15),
              // ),
              // SizedBox(width: Constant.SIZE_08),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.notificationType??"",
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium!.copyWith(color: Colors.white),
                    ),
                    Text(
                      data.message??"",
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall!.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Text(
            data.timestamp??"",
            textAlign: TextAlign.end,
            style: Theme.of(
              context,
            ).textTheme.titleSmall!.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
