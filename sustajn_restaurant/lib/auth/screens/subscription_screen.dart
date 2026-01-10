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
import 'package:sustajn_restaurant/utils/utility.dart';

import '../../common_widgets/app_loading.dart';
import '../../common_widgets/empty_list_place_holder.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../network_provider/network_provider.dart';
import '../model/plan_model.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

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
                rightText: "Retry",
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
          title: "",
          leading: CustomBackButton(),
        ).getAppBar(context),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

              SizedBox(height: Constant.PADDING_HEIGHT_10),

              Text(
                Strings.SELECT_PLAN,
                style: theme.textTheme.titleSmall!.copyWith(
                  color: Colors.white,
                ),
              ),

              SizedBox(height: Constant.CONTAINER_SIZE_16),
              (authState.plans.isEmpty)
                  ? EmptyState(title: "No data found")
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
                        );
                      },
                    ),
              SizedBox(height: Constant.CONTAINER_SIZE_16),
              SizedBox(
                width: double.infinity,
                child: SubmitButton(
                  onRightTap: () {
                    Utils.navigateToPushScreen(
                      context,
                      TermsAndConditionScreen(),
                    );
                  },
                  rightText: "Proceed to Terms & Conditions",
                ),
              ),
            ],
          ),
        ),
      ),
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
}

class PlanCard extends StatelessWidget {
  final PlanModel plan;
  final VoidCallback onTap;

  const PlanCard({super.key, required this.plan, required this.onTap});

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
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0A4D2E), Color(0xFF052F1E)],
                ),
                borderRadius: BorderRadius.circular(24),
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
                        plan.planName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (plan.isSelected)
                        const Icon(Icons.check_circle, color: Colors.white),
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
                            size: 18,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              feature,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
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
                        Utils.navigateToPushScreen(
                          context,
                          SubscriptionDetailsScreen(planModel: plan),
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
                        "Learn More",
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
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                plan.totalContainers.toString(),
                style: const TextStyle(
                  color: Color(0xFF052F1E),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
