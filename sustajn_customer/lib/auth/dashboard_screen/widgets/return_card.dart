import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants/number_constants.dart';

class ReturnCard extends StatelessWidget {
  final String date;
  final String title;
  final String subTitle;
  final String volume;
  final int qty;
  final String daysLeft;
  final Color daysBadgeColor;

  const ReturnCard({Key? key,
    required this.date, required this.title,
    required this.subTitle, required this.qty,
    required this.daysLeft, required this.daysBadgeColor,
    required this.volume}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_16, vertical: Constant.SIZE_08),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
        ),
        child: Padding(
          padding:  EdgeInsets.all(Constant.CONTAINER_SIZE_12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(date, style: textTheme.bodySmall?.copyWith(
                  //     color: Constant.subtitleText, fontSize: Constant.LABEL_TEXT_SIZE_14)),
                  // SizedBox(height: Constant.SIZE_08),
                  Container(
                    width: Constant.CONTAINER_SIZE_56,
                    height: Constant.CONTAINER_SIZE_56,
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(Constant.SIZE_08),
                    ),
                    child: Center(
                      child: Icon(Icons.inbox,
                          size: Constant.CONTAINER_SIZE_30, color: theme.primaryColor),
                    ),
                  ),
                ],
              ),

              SizedBox(width: Constant.CONTAINER_SIZE_12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.black, fontSize: Constant.LABEL_TEXT_SIZE_16,
                        fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                    SizedBox(height: Constant.SIZE_04),
                    Text(subTitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.black, fontSize: Constant.LABEL_TEXT_SIZE_14),
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                    Text(volume,
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.black, fontSize: Constant.LABEL_TEXT_SIZE_14),
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),

              SizedBox(width: Constant.CONTAINER_SIZE_12),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(Icons.inventory_2,
                          size: Constant.CONTAINER_SIZE_14, color: theme.primaryColor),
                      SizedBox(width: Constant.SIZE_06),
                      Text(qty.toString(), style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.primaryColor, fontSize: Constant.LABEL_TEXT_SIZE_16)),
                    ],
                  ),
                  SizedBox(height: Constant.SIZE_08),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: Constant.SIZE_08, vertical: Constant.SIZE_06),
                    decoration: BoxDecoration(
                      color: daysBadgeColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(daysLeft, style: theme.textTheme.bodySmall?.copyWith(color: Colors.white, fontSize: Constant.CONTAINER_SIZE_12)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}