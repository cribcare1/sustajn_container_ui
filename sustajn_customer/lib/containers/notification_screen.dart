import 'package:flutter/material.dart';
import '../../constants/number_constants.dart';
import '../../models/notice_model.dart';
import '../../utils/theme_utils.dart';

class NotificationScreen extends StatelessWidget {

  NotificationScreen({super.key});

  final List<NoticeModel> notifications = [

    NoticeModel(
      title: "Your Order\nSahara Sizzle",
      subtitle: "Round Bowl | Dip Cup | Rectangular Container",
      dateTime: "01/12/2024 | 10:00am",
      icon: "",
      hasActions: true,
    ),

    NoticeModel(
      title: "Your borrowed product is due for return in 1 days.Please return it by 01/12/2025.",
      icon: "assets/icons/warning_icon.png",
      subtitle: "",
      dateTime: "30/11/2025 | 09:00am",
      hasActions: false,
    ),

    NoticeModel(
      title:
      "As the 7-day limit has been crossed, we have initiated the process "
          "to charge the replacement fee of [Amount]",
      icon: "assets/icons/siren_icon.png",
      subtitle: "",
      dateTime: "30/11/2025 | 09:00am",
      hasActions: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: Constant.SIZE_18),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Notifications",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontFamily: "DMSans",
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Mark all as read",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontFamily: "DMSans",
                    color: Constant.gold,
                  ),
                ),
              ],
            ),

            SizedBox(height: Constant.SIZE_15),

            Expanded(
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return _notificationCard(
                    context,
                    notifications[index],
                    theme,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _notificationCard(BuildContext context,
      NoticeModel item,
      ThemeData theme) {
    return Container(
      margin: EdgeInsets.only(bottom: Constant.SIZE_10),
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
      decoration: BoxDecoration(
        color: Constant.grey.withOpacity(0.12),
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
        border: Border.all(color: Colors.white24, width: 0.4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(item.icon != "")...[
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme
                    .of(context)
                    .secondaryHeaderColor,

              ),
              child: Image.asset(item.icon),
            ),
            SizedBox(width: 8),
          ],

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  item.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                if(item.subtitle.isNotEmpty) ...[
                  SizedBox(height: Constant.SIZE_06),
                  Text(
                    item.subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],

                if(item.hasActions)...[
                  SizedBox(height: Constant.SIZE_10),

                  Row(
                    children: [

                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_30),
                            border: Border.all(color: Constant.gold),
                          ),
                          child: Center(
                            child: Text(
                              "View",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontFamily: "DMSans",
                                color: Constant.gold,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: Constant.SIZE_10),

                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: Constant.gold,
                            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_30),
                          ),
                          child: Center(
                            child: Text(
                              "Confirm",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontFamily: "DMSans",
                                color: theme.scaffoldBackgroundColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                SizedBox(height: Constant.SIZE_08),

                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    item.dateTime,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: "DMSans",
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
