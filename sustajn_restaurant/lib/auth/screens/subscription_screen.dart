import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/auth/screens/subscription_details_screen.dart';
import 'package:sustajn_restaurant/auth/screens/terms_and_condition_screen.dart';
import 'package:sustajn_restaurant/common_widgets/card_widget.dart';
import 'package:sustajn_restaurant/common_widgets/custom_app_bar.dart';
import 'package:sustajn_restaurant/common_widgets/custom_back_button.dart';
import 'package:sustajn_restaurant/common_widgets/submit_button.dart';
import 'package:sustajn_restaurant/notifier/login_notifier.dart';
import 'package:sustajn_restaurant/provider/login_provider.dart';
import 'package:sustajn_restaurant/utils/nav_utils.dart';
import 'package:sustajn_restaurant/utils/utility.dart';

import '../../common_widgets/app_loading.dart';
import '../../common_widgets/empty_list_place_holder.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../network_provider/network_provider.dart';
import '../../provider/profile_provider.dart';
import '../model/plan_model.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  final String? previousScreen;
  const SubscriptionScreen({super.key,this.previousScreen = ""});

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getNetworkData(ref.read(authNotifierProvider));
    });
    super.initState();
  }

  Future<void> _refreshIndicator() async {
    _getNetworkData(ref.read(authNotifierProvider));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);
    if (authState.isPlanLoading == true) {
      return Container(
        height: double.infinity,
        width: double.infinity,
        color: theme.primaryColor,
        child: Center(child: AppLoading()),
      );
    }
    if (authState.planError != null) {
      return Container(
        height: double.infinity,
        width: double.infinity,
        color: theme.primaryColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                authState.planError!,
                style: theme.textTheme.titleMedium!.copyWith(color: Colors.red),
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_10),
              SubmitButton(
                onRightTap: () {
                  _refreshIndicator();
                },
                rightText: Strings.RETRY,
              ),
            ],
          ),
        ),
      );
    }
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        appBar: CustomAppBar(
          title: widget.previousScreen == 'profile' ? Strings.CHOOSE_PLAN : '',
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.keyboard_arrow_left, color: Colors.white),
          ),
        ).getAppBar(context),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.previousScreen == "") ...[
                SizedBox(height: Constant.CONTAINER_SIZE_16),
                Row(
                  children: List.generate(4, (index) {
                    bool active = index <= 3;
                    return Expanded(
                      child: Container(
                        height: Constant.SIZE_05,
                        margin: EdgeInsets.only(
                          right: index == 3 ? 0 : Constant.SIZE_10,
                        ),
                        decoration: BoxDecoration(
                          color: active ? Constant.gold : Colors.white,
                          borderRadius: BorderRadius.circular(Constant.SIZE_10),
                        ),
                      ),
                    );
                  }),
                ),

                SizedBox(height: Constant.CONTAINER_SIZE_16),

                Text(
                  Strings.CHOOSE_PLAN,
                  style: theme.textTheme.titleLarge!.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
              SizedBox(height: Constant.PADDING_HEIGHT_10),

              Text(
                Strings.SELECT_PLAN,
                style: theme.textTheme.titleSmall!.copyWith(
                  color: Colors.white,
                ),
              ),

              SizedBox(height: Constant.CONTAINER_SIZE_16),
              (authState.plans.isEmpty)
                  ? Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      EmptyState(title: "No data found"),
                      SizedBox(height: Constant.CONTAINER_SIZE_10),
                      SubmitButton(
                        onRightTap: () {
                          _refreshIndicator();
                        },
                        rightText: Strings.RETRY,
                      ),
                    ],
                  )
                  : ListView.separated(
                      itemCount: authState.plans.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) =>
                          SizedBox(height: Constant.CONTAINER_SIZE_25),
                      itemBuilder: (context, index) {
                        return PlanCard(
                          plan: authState.plans[index],
                          onTap: () {
                            setState(() {
                              for (var p in authState.plans) {
                                p.isSelected = false;
                              }
                              authState.plans[index].isSelected = true;
                              final selectedPlan = authState.plans.firstWhere(
                                (plan) => plan.isSelected,
                                orElse: () =>
                                    throw Exception('No plan selected'),
                              );
                              authState.setPlanId(selectedPlan.planId);
                            });
                          },
                          previousScreen: widget.previousScreen ?? "",
                          onPlanNameTap: (planId) {
                            showConfirmationDialog(context, planId);
                          },
                        );
                      },
                    ),
              if (widget.previousScreen == "" && authState.plans.isNotEmpty) ...[
                SizedBox(height: Constant.CONTAINER_SIZE_16),
                SizedBox(
                  width: double.infinity,
                  child: SubmitButton(
                    onRightTap: () {
                      if (authState.planId != 0) {
                        NavUtil.navigateToPushScreen(
                          context,
                          TermsAndConditionScreen(),
                        );
                      } else {
                        showCustomSnackBar(
                          context: context,
                          message: Strings.SELECT_SUBSCRIPTION,
                          color: Colors.red,
                        );
                      }
                    },
                    rightText: "Proceed to Terms & Conditions",
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showConfirmationDialog(BuildContext context, int planId) async {
    final theme = Theme.of(context);
    bool isLoading = false;

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: theme.scaffoldBackgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
              ),
              title: Text(
                Strings.CONFIRM_UPDATE,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),

              content: Text(
                Strings.UPDATE_SUBSCRIPTION_PLAN,
                style: TextStyle(color: Colors.grey.shade300),
              ),

              actions: [
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          NavUtil.popScreen(context, 1);
                        },
                  child: Text(Strings.NO, style: TextStyle(color: Colors.grey)),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFC8B531),
                    minimumSize: Size(
                      Constant.CONTAINER_SIZE_110,
                      Constant.CONTAINER_SIZE_40,
                    ),
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() => isLoading = true);

                          try {
                            await _upgradeSubscriptionPlanNetworkCall(planId);
                            NavUtil.popScreen(context, 4);
                          } catch (e) {
                            setState(() => isLoading = false);
                          }
                        },
                  child: isLoading
                      ? SizedBox(
                          height: Constant.CONTAINER_SIZE_20,
                          width: Constant.CONTAINER_SIZE_20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.primaryColor,
                          ),
                        )
                      : Text(
                          Strings.UPDATE,
                          style: TextStyle(color: theme.primaryColor),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _getNetworkData(AuthState state) async {
    try {
      state.setIsPlanLoading(true);
      final isNetworkAvailable = await ref
          .read(networkProvider.notifier)
          .isNetworkAvailable();

      if (!isNetworkAvailable) {
        showCustomSnackBar(
          context: context,
          message: Strings.NO_INTERNET_CONNECTION,
          color: Colors.red,
        );
        return;
      }

      ref.read(subscriptionProvider({}));
    } catch (e) {
      Utils.printLog("API Error: $e");
    }
  }

  Map<String, dynamic> getJsonData(int planId) {
    final data = {"userId": Utils.userId, "subscriptionPlanId": planId};
    return data;
  }

  _upgradeSubscriptionPlanNetworkCall(int planId) async {
    Utils.printLog('upgrade Subscription Plan Network call');

    final isNetworkAvailable = await ref
        .read(networkProvider.notifier)
        .isNetworkAvailable();

    if (!isNetworkAvailable) {
      Utils.showToast(Strings.NO_INTERNET_CONNECTION);
      return false;
    }

    try {
      await ref.read(
        updateSubscriptionPlanProvider(getJsonData(planId)).future,
      );
      return true;
    } catch (e) {
      Utils.printLog('update Subscription Plan error: $e');
      return false;
    }
  }
}

class PlanCard extends StatelessWidget {
  final PlanModel plan;
  final VoidCallback onTap;
  final String previousScreen;
  final void Function(int planId)? onPlanNameTap;

  const PlanCard({
    super.key,
    required this.plan,
    required this.onTap,
    required this.previousScreen,
    this.onPlanNameTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SubscriptionCard(
            padding: 4.0,
            child: Container(
              padding: EdgeInsets.all(Constant.CONTAINER_SIZE_24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0A4D2E), Color(0xFF052F1E)],
                ),
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_24),
                border: Border.all(
                  color: Theme.of(context).secondaryHeaderColor,
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        plan.planName??"",
                        style:  TextStyle(
                          color: Colors.white,
                          fontSize: Constant.CONTAINER_SIZE_22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (plan.isSelected)
                        GestureDetector(
                          onTap: () {
                            onPlanNameTap?.call(plan.planId);
                          },
                          child: Icon(Icons.check_circle, color: Colors.white),
                        ),
                    ],
                  ),
                  SizedBox(height: Constant.CONTAINER_SIZE_10),
                  ...plan.features.map(
                    (feature) => Padding(
                      padding: EdgeInsets.only(bottom: Constant.SIZE_08),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check,
                            color: Theme.of(context).secondaryHeaderColor,
                            size: Constant.CONTAINER_SIZE_18,
                          ),
                          SizedBox(width: Constant.CONTAINER_SIZE_12),
                          Expanded(
                            child: Text(
                              feature,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: Constant.CONTAINER_SIZE_14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: Constant.CONTAINER_SIZE_10),
                  Center(
                    child: OutlinedButton(
                      onPressed: () {
                        NavUtil.navigateToPushScreen(
                          context,
                          SubscriptionDetailsScreen(
                            planModel: plan,
                            previousScreen: previousScreen,
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            Constant.CONTAINER_SIZE_16,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: Constant.CONTAINER_SIZE_40,
                          vertical: Constant.CONTAINER_SIZE_12,
                        ),
                      ),
                      child: Text(
                        Strings.LEARN_MORE,
                        style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: -18,
            right: Constant.CONTAINER_SIZE_20,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: Constant.CONTAINER_SIZE_16,
                vertical: Constant.SIZE_08,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37),
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_10),
              ),
              child: Text(
                "Ð${plan.totalContainers.toString()}",
                style: TextStyle(
                  color: Color(0xFF052F1E),
                  fontWeight: FontWeight.bold,
                  fontSize: Constant.CONTAINER_SIZE_16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
