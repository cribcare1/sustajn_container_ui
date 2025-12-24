import 'package:flutter/material.dart';
import '../../constants/number_constants.dart';

class SubscriptionPlanBottomSheet extends StatelessWidget {
  const SubscriptionPlanBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: theme.primaryColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(Constant.CONTAINER_SIZE_20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _header(context),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
                  children: [
                    _planCard(context),
                    SizedBox(height: Constant.CONTAINER_SIZE_20),
                    _dateSection(context),
                    SizedBox(height: Constant.CONTAINER_SIZE_30),
                    _viewAllPlansButton(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _header(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Constant.CONTAINER_SIZE_16,
        vertical: Constant.CONTAINER_SIZE_12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Subscription Plan',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.white
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: CircleAvatar(
              radius: Constant.CONTAINER_SIZE_16,
              backgroundColor: theme.colorScheme.onSurface.withOpacity(0.1),
              child: Icon(
                Icons.close,
                size: Constant.CONTAINER_SIZE_18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _planCard(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(Constant.SIZE_04),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
            border: Border.all(
              color: Constant.grey,
              width: Constant.SIZE_001,
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.grey.withOpacity(0.2),
                  theme.scaffoldBackgroundColor.withOpacity(0.3),
                ],

              ),
              // color: theme.primaryColor,
              borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_18),
              border: Border.all(
                color: Constant.gold,
                width: Constant.SIZE_005,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pay-per-use',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: Constant.CONTAINER_SIZE_12),

                _bulletText(context, 'Lorem ipsum dolor sit amet consectetur. Vitae eu s'),
                _bulletText(context, 'Lorem ipsum dolor sit amet consectetur. Vitae eu'),
                _bulletText(context, 'Lorem Ipsum'),

                SizedBox(height: Constant.CONTAINER_SIZE_16),

                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Constant.CONTAINER_SIZE_30,
                      vertical: Constant.SIZE_08,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
                      border: Border.all(
                        color: Constant.gold,
                        width: Constant.SIZE_01,
                      ),
                    ),
                    child: Text(
                      'Learn More',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Constant.gold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // PRICE TAG
        Positioned(
          right: Constant.CONTAINER_SIZE_16,
          top: Constant.CONTAINER_SIZE_12,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Constant.CONTAINER_SIZE_12,
              vertical: Constant.SIZE_06,
            ),
            decoration: BoxDecoration(
              color: Constant.gold,
              borderRadius: BorderRadius.circular(Constant.SIZE_08),
            ),
            child: Text(
              '₹ 500/month',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _bulletText(BuildContext context, String text) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: Constant.SIZE_08),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check,
            size: Constant.CONTAINER_SIZE_16,
            color: Constant.gold,
          ),
          SizedBox(width: Constant.SIZE_08),
          Expanded(
            child: Text(
              text,
              maxLines: Constant.MAX_LINE_2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color:Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateSection(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
      decoration: BoxDecoration(
        color: Constant.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
        border: Border.all(
          color: Constant.grey.withOpacity(0.2)
        )
      ),
      child: Row(
        children: [
          Expanded(child: _dateItem(context, 'Start Date', '01/11/2025')),
          Expanded(child: _dateItem(context, 'End Date', '30/11/2025')),
        ],
      ),
    );
  }

  Widget _dateItem(BuildContext context, String title, String date) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(
          Icons.calendar_month,
          size: Constant.CONTAINER_SIZE_18,
          color: Colors.white,
        ),
        SizedBox(height: Constant.SIZE_06),
        Text(
          title,
          style: theme.textTheme.bodySmall?.copyWith(
            color:Colors.white.withOpacity(0.8),
          ),
        ),
        SizedBox(height: Constant.SIZE_04),
        Text(
          date,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _viewAllPlansButton(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: Constant.CONTAINER_SIZE_50,
      decoration: BoxDecoration(
        color: Constant.gold,
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_14),
      ),
      alignment: Alignment.center,
      child: Text(
        'View all plans',
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
