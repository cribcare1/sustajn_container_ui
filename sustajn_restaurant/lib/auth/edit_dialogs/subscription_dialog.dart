import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/auth/screens/subscription_details_screen.dart';
import 'package:sustajn_restaurant/auth/screens/subscription_screen.dart';
import 'package:sustajn_restaurant/common_widgets/submit_button.dart';
import 'package:sustajn_restaurant/models/get_profile_data.dart';
import 'package:sustajn_restaurant/provider/profile_provider.dart';
import 'package:sustajn_restaurant/utils/nav_utils.dart';

import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../utils/utility.dart';

class SubscriptionPlanBottomSheet extends ConsumerWidget {
  const SubscriptionPlanBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final profileState = ref.watch(profileProvider);
    final subscription =
        profileState.getProfileData?.data!.subscriptionResponse;
    return SafeArea(
      top: false,
      bottom: true,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Utils.buildFloatingHeader(context),
            SizedBox(height: Constant.SIZE_08),
            Padding(
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
                          _planCard(
                            context,
                            (subscription != null) ? subscription : null,
                          ),
                          SizedBox(height: Constant.CONTAINER_SIZE_30),
                          _viewAllPlansButton(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Constant.CONTAINER_SIZE_16,
        vertical: Constant.CONTAINER_SIZE_12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            Strings.SUBSCRIPTION_PLAN,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _planCard(BuildContext context, SubscriptionResponse? data) {
    final theme = Theme.of(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.all(Constant.SIZE_04),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
            border: Border.all(color: Constant.grey, width: Constant.SIZE_001),
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
                  data!.planName ?? "",
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: Constant.CONTAINER_SIZE_12),
                _bulletText(context, data.description ?? ""),
                SizedBox(height: Constant.CONTAINER_SIZE_16),

                InkWell(
                  onTap: () {
                    NavUtil.navigateToPushScreen(
                      context,
                      SubscriptionDetailsScreen(
                        subscriptionResponse: data,
                        previousScreen: 'profile',
                      ),
                    );
                  },
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Constant.CONTAINER_SIZE_30,
                        vertical: Constant.SIZE_08,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          Constant.CONTAINER_SIZE_20,
                        ),
                        border: Border.all(
                          color: Constant.gold,
                          width: Constant.SIZE_01,
                        ),
                      ),
                      child: Text(
                        Strings.LEARN_MORE,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Constant.gold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        Positioned(
          top: Constant.NEGATIVE_HEIGHT_10,
          right: Constant.CONTAINER_SIZE_24,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Constant.CONTAINER_SIZE_12,
              vertical: Constant.SIZE_08,
            ),
            decoration: BoxDecoration(
              color: Constant.gold,
              borderRadius: BorderRadius.circular(Constant.SIZE_08),
            ),
            child: Text(
              "Ð ${data.feeType.toString()}",
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
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.white),
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
        border: Border.all(color: Constant.grey.withOpacity(0.2)),
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
            color: Colors.white.withOpacity(0.8),
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
    return SubmitButton(
      onRightTap: () {
        NavUtil.navigateToPushScreen(
          context,
          SubscriptionScreen(previousScreen: 'profile'),
        );
      },
      rightText: Strings.VIEW_ALL_PLAN,
    );
  }
}
