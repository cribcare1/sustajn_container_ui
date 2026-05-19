import 'package:flutter/material.dart';
import 'package:sustajn_customer/common_widgets/custom_app_bar.dart';
import 'package:sustajn_customer/common_widgets/custom_back_button.dart';
import '../../constants/number_constants.dart';
import '../../utils/theme_utils.dart';
import '../constants/string_utils.dart';
import '../widgets/no_data_custom_text.dart';
import 'models/notice_model.dart';
import 'notification_dialog.dart';

class NotificationScreen extends StatelessWidget {

  NotificationScreen({super.key});

  final List<NoticeModel> notifications = [

    // NoticeModel(
    //   title: Strings.TITLE_1,
    //   icon: "assets/icons/right_check.png",
    //   subtitle: Strings.SUB_TITLE_,
    //   dateTime: "08/01/2026 | 10:00",
    //   // icon: "assets/icons/check.png",
    //   hasActions: true,
    // ),
    // NoticeModel(
    //   title: Strings.TITLE_2,
    //   icon: "assets/icons/icon_1.png",
    //   subtitle: "",
    //   dateTime: "08/10/2026 | 23:00",
    //   hasActions: false,
    // ),
    //
    // NoticeModel(
    //   title: Strings.TITLE_3,
    //   icon: "assets/icons/warning_icon.png",
    //   subtitle: "",
    //   dateTime: "08/11/2026 | 09:00",
    //   hasActions: false,
    // ),
    //
    // NoticeModel(
    //   title: Strings.TITLE_4,
    //   icon: "assets/icons/warning_icon.png",
    //   subtitle: "",
    //   dateTime: "30/11/2025 | 09:00",
    //   hasActions: false,
    // ),
    // NoticeModel(
    //   title: Strings.TITLE_5,
    //   icon: "assets/icons/warning_icon.png",
    //   subtitle: "",
    //   dateTime: "30/11/2025 | 09:00",
    //   hasActions: false,
    // ),
    // NoticeModel(
    //   title: Strings.TITLE_6,
    //   icon: "assets/icons/clock_icon.png",
    //   subtitle: "",
    //   dateTime: "30/11/2025 | 09:00",
    //   hasActions: false,
    // ),
    // NoticeModel(
    //   title: Strings.TITLE_6,
    //   icon: "assets/icons/clock_icon.png",
    //   subtitle: "",
    //   dateTime: "30/11/2025 | 09:00",
    //   hasActions: false,
    // ),
    // NoticeModel(
    //   title: Strings.TITLE_6,
    //   icon: "assets/icons/clock_icon.png",
    //   subtitle: "",
    //   dateTime: "30/11/2025 | 09:00",
    //   hasActions: false,
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(color:Colors.white),),
        backgroundColor: theme.scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(
    Icons.arrow_back_ios,
        color: Colors.white,
        size: Constant.CONTAINER_SIZE_20),
        onPressed:(){
          Navigator.pop(context);
        },
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: Constant.CONTAINER_SIZE_16,
            ),
            child: Center(
              // child: Text(
              //   'Mark all as read',
              //   style: Theme.of(context).textTheme.titleSmall!.copyWith(
              //     color: Constant.gold,
              //     decoration: TextDecoration.underline,
              //     decorationColor: Constant.gold,
              //     decorationThickness: 1.5,
              //   ),
              // ),
            ),
          ),
        ],

      ),
      body: Padding(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: notifications.isEmpty
        ? Center(
                child: NoDataFoundCustomText(
                  text: Strings.NO_NOTIFICATIONS,
                ),
              )
       : ListView.builder(
                itemCount: notifications.length,itemBuilder: (context, index) {
                final item = notifications[index];

                return InkWell(
                  borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
                  onTap: () {
                    if (index == 5) {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const NotificationDialog(),
                      );
                    }
                  },
                  child: _notificationCard(
                    context,
                    item,
                    theme,
                    index,
                  ),
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
      ThemeData theme,
      int index,
      ) {
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
              height: Constant.CONTAINER_SIZE_30,
              width: Constant.CONTAINER_SIZE_30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme
                    .of(context)
                    .secondaryHeaderColor,
              ),
              child: Image.asset(item.icon),
            ),
            SizedBox(width: Constant.SIZE_05),
          ],

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                if (item.title.contains('\n')) ...[
                  Text(
                    item.title.split('\n')[0],
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white70, // status text
                    ),
                  ),
                  SizedBox(height: Constant.CONTAINER_SIZE_1),
                  Text(
                    item.title.split('\n')[1],
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: Constant.CONTAINER_SIZE_14,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ] else
                  Text(
                    item.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: Constant.CONTAINER_SIZE_14,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if(item.subtitle.isNotEmpty) ...[
                  SizedBox(height: Constant.SIZE_06),
                  Text(
                    item.subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],

                if(item.hasActions)...[
                  SizedBox(height: Constant.SIZE_10),
                  Row(
                    children: [
                      SizedBox(width: Constant.SIZE_10),
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
          if (index == 5)
            Icon(
              Icons.chevron_right,
              color: Colors.white70,
              size: Constant.CONTAINER_SIZE_22,
            )
        ],
      ),
    );
  }
}
