import 'package:sustajn_restaurant/common_widgets/card_widget.dart';
import 'package:sustajn_restaurant/common_widgets/custom_app_bar.dart';
import 'package:sustajn_restaurant/common_widgets/custom_back_button.dart';
import 'package:sustajn_restaurant/constants/imports_util.dart';

import 'notification_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationModel> notificationList = [
    NotificationModel(
      title: "Order Delivered",
      description: "Your order #ORD-0245 has been delivered",
      icon: Icons.check,
      color: Colors.green,
      dateTime: "01/12/2024 5:00 PM",
    ),
    NotificationModel(
      title: "Order Rejected",
      description: "Your order #ORD-0245 has been delivered",
      icon: Icons.close,
      color: Colors.red,
      dateTime: "01/12/2024 5:00 PM",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: "Notification",
        leading: CustomBackButton(),
        action: [
          TextButton(
            onPressed: () {},
            child: Text(
              "Mark al as read",
              style: theme.textTheme.titleSmall!.copyWith(
                color: theme.secondaryHeaderColor,
              ),
            ),
          ),
        ],
      ).getAppBar(context),
      body: ListView.separated(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
        itemCount: notificationList.length,
        itemBuilder: (context, index) =>
            _notificationCard(notificationList[index]),
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
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: data.color,
                ),
                padding: EdgeInsets.all(3),
                child: Icon(data.icon, size: 15),
              ),
              SizedBox(width: Constant.SIZE_08),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium!.copyWith(color: Colors.white),
                    ),
                    Text(
                      data.description,
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
            data.dateTime,
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
