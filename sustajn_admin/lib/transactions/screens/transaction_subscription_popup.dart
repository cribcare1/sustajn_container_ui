import 'package:flutter/material.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../models/transaction_subscription_data.dart';

class SubscriptionDetailsDialog extends StatelessWidget {
  final DateWiseSubscription items;

  const SubscriptionDetailsDialog({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
      decoration: BoxDecoration(
        color: Constant.PrimaryColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Constant.CONTAINER_SIZE_30),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
            Container(
              width: Constant.CONTAINER_SIZE_60,
              height: Constant.SIZE_05,
              decoration: BoxDecoration(
                color: Constant.white,
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
              ),
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_20),

            Row(
              children: [
                Text(
                  Strings.SUBSCRIPTION_DETAILS,
                  style: TextStyle(
                    color: Constant.BeigeColor,
                    fontSize: Constant.CONTAINER_SIZE_20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.close,
                    color: Constant.white,
                  ),
                )
              ],
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_24),


            Container(
              padding: EdgeInsets.all(Constant.CONTAINER_SIZE_18),
              decoration: BoxDecoration(
                color: Constant.white.withOpacity(.08),
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_18),
                border: Border.all(
                  color: Constant.PrimaryDarkColor,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    items.name!,
                    style: TextStyle(
                      color: Constant.BeigeColor,
                      fontSize: Constant.CONTAINER_SIZE_18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  SizedBox(height: Constant.SIZE_10),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Constant.BeigeColor,
                        size: Constant.CONTAINER_SIZE_18,
                      ),
                      SizedBox(width: Constant.SIZE_06),
                      Expanded(
                        child: Text(
                          items.restaurantAddress!,
                          style: TextStyle(
                            color: Constant.BeigeColor,
                            fontSize: Constant.CONTAINER_SIZE_14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_35),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  Strings.DIRHAM_IMG,
                  height: Constant.CONTAINER_SIZE_40,
                  color: Constant.PrimaryAssentColor,
                ),
                SizedBox(width: Constant.SIZE_06),
                Text(
                  '${items.amount!}',
                  style: TextStyle(
                    color: Constant.PrimaryAssentColor,
                    fontSize: Constant.CONTAINER_SIZE_40,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            SizedBox(height: Constant.SIZE_08),

            Text(
              items.formattedDate!,
              style: TextStyle(
                color: Constant.BeigeColor,
                fontSize: Constant.CONTAINER_SIZE_16,
              ),
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_40),

            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  Text(
                    Strings.PLAN_TYPE,
                    style: TextStyle(
                      color: Constant.BeigeColor.withOpacity(.8),
                      fontSize: Constant.CONTAINER_SIZE_14,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_12),

             Align(
              alignment: Alignment.centerLeft,
              child: Text(
                Strings.PAY_USE,
                style: TextStyle(
                  color: Constant.BeigeColor,
                  fontSize: Constant.CONTAINER_SIZE_20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_30),
          ],
        ),
      ),
    );
  }
}