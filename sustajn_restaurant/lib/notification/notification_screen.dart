import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/common_widgets/card_widget.dart';
import 'package:sustajn_restaurant/common_widgets/custom_app_bar.dart';
import 'package:sustajn_restaurant/common_widgets/custom_back_button.dart';
import 'package:sustajn_restaurant/constants/imports_util.dart';
import 'package:sustajn_restaurant/notification/notification_provider.dart';
import 'package:sustajn_restaurant/notification/notification_state.dart';

import '../constants/string_utils.dart';
import '../network_provider/network_provider.dart';
import '../utils/utility.dart';
import 'notification_model.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  // List<NotificationModel> notificationList = [
  //   NotificationModel(
  //     title: "Order Delivered",
  //     description: "Your order #ORD-0245 has been delivered",
  //     icon: Icons.check,
  //     color: Colors.green,
  //     dateTime: "01/12/2024 5:00 PM",
  //   ),
  //   NotificationModel(
  //     title: "Order Rejected",
  //     description: "Your order #ORD-0245 has been delivered",
  //     icon: Icons.close,
  //     color: Colors.red,
  //     dateTime: "01/12/2024 5:00 PM",
  //   ),
  // ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationProvider).setContext(context);
      _getOrderNetworkCall();
    });
    super.initState();
  }

  _getOrderNetworkCall() async {
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
          : ListView.separated(
              padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
              itemCount: notificationState.notificationList.length,
              itemBuilder: (context, index) =>
                  _notificationCard(notificationState.notificationList[index]),
              separatorBuilder: (context, index) =>
                  SizedBox(height: Constant.CONTAINER_SIZE_10),
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
