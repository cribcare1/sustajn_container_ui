import 'package:container_tracking/common_widgets/custom_back_button.dart';
import 'package:container_tracking/constants/imports.util.dart';
import 'package:container_tracking/notification/models/notice_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/string_utils.dart';

class NotificationScreen extends StatelessWidget{

  NotificationScreen({super.key});

  final List<NoticeModel> notifications = [

    NoticeModel(
      title: Strings.TITLE_1,
      icon: "assets/icons/icon_3.png",
      subtitle: Strings.SUBTITLE_1,
      dateTime: "01/12/2024 | 05:00pm",
      hasActions: false,
    ),
    NoticeModel(
      title: Strings.TITLE_2,
      icon: "assets/icons/icon_2.png",
      subtitle: Strings.SUBTITLE_2,
      dateTime: "01/12/2024 | 10:00am",
      hasActions: false,
    ),
    NoticeModel(
      title: Strings.TITLE_3,
      icon: "assets/icons/icon_2.png",
      subtitle: Strings.SUBTITLE_3,
      dateTime: "01/12/2024 | 10:00am",
      hasActions: false,
    ),
    NoticeModel(
      title: Strings.TITLE_4,
      icon: "assets/icons/icon_1.png",
      subtitle: Strings.SUBTITLE_4,
      dateTime: "25/11/2024 | 11:24am",
      hasActions: false,
    ),
    NoticeModel(
      title: Strings.TITLE_5,
      icon: "assets/icons/icon_1.png",
      subtitle: Strings.SUBTITLE_5,
      dateTime: "25/12/2024 | 11:24am",
      hasActions: false,
    ),
  ];
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.NOTIFICATION,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
        ),
        leading: CustomBackButton(),
        backgroundColor: theme.scaffoldBackgroundColor,
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: Constant.CONTAINER_SIZE_16,
            ),
            child: Center(
              child: Text(
                Strings.MARK_ALL_READ,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Constant.gold,
                  decoration: TextDecoration.underline,
                  decorationColor: Constant.gold,
                  decorationThickness: 1.5,
                ),
              ),
            ),
          )
        ],
      ),

      body: Padding(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: notifications.length,itemBuilder: (context, index){
                  final item = notifications[index];

                  return InkWell(
                    borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
                    onTap: () {
                      if (index == 5) {
                      }
                    },
                    child: _notificationCard(
                      context,
                      item,
                      theme,
                      index,
                    ),
                  );
              }
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _notificationCard(BuildContext context,
      NoticeModel item,
      ThemeData theme,
      int index,
  ){
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
          if(item.icon !="")...[
            Container(
              height: Constant.CONTAINER_SIZE_30,
              width: Constant.CONTAINER_SIZE_30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).secondaryHeaderColor,
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