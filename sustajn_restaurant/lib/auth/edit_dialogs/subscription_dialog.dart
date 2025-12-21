import 'package:flutter/material.dart';
import '../../constants/number_constants.dart';

class UpgradeBottomSheet extends StatelessWidget {
  const UpgradeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(
          left: Constant.CONTAINER_SIZE_12,
          right: Constant.CONTAINER_SIZE_12,
          bottom: Constant.CONTAINER_SIZE_12,
        ),
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: Constant.CONTAINER_SIZE_40,
              height: Constant.SIZE_04,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  Constant.CONTAINER_SIZE_10,
                ),
              ),
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_12),

            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.close,
                    color: Colors.white),
              ),
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_12),

            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      Constant.CONTAINER_SIZE_16,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Popular",
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: Constant.CONTAINER_SIZE_12),

                      _featureRow(theme, " Lorem ipsum dolor sit amet consectetur. Vitae eu"),
                      _featureRow(theme, " Lorem ipsum dolor sit amet consectetur. Vitae eu"),
                      _featureRow(theme, " Lorem Ipsum"),
                    ],
                  ),
                ),

                Positioned(
                  top: -Constant.CONTAINER_SIZE_12,
                  right: Constant.CONTAINER_SIZE_16,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Constant.CONTAINER_SIZE_12,
                      vertical: Constant.SIZE_06,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFC8B531),
                      borderRadius: BorderRadius.circular(
                        Constant.CONTAINER_SIZE_12,
                      ),
                    ),
                    child: Text(
                      "₹ 500/month",
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_20),

            Row(
              children: [
                Expanded(
                  child: _dateTile(
                    theme,
                    title: "Start Date",
                    value: "01/11/2025",
                  ),
                ),
                SizedBox(width: Constant.CONTAINER_SIZE_12),
                Expanded(
                  child: _dateTile(
                    theme,
                    title: "End Date",
                    value: "30/11/2025",
                  ),
                ),
              ],
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_24),

            SizedBox(
              width: double.infinity,
              height: Constant.CONTAINER_SIZE_50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFC8B531),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  "Upgrade",
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureRow(ThemeData theme, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check, size: Constant.CONTAINER_SIZE_16, color: theme.scaffoldBackgroundColor),
        SizedBox(width: Constant.CONTAINER_SIZE_10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _dateTile(
      ThemeData theme, {
        required String title,
        required String value,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.labelMedium?.copyWith(
          color: Colors.white
        )),
        SizedBox(height: Constant.SIZE_06),
        Row(
          children: [
            Icon(Icons.calendar_today_outlined,
                size: Constant.CONTAINER_SIZE_18,
            color: Colors.white,),
            SizedBox(width: Constant.SIZE_06),
            Flexible(
              child: Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
