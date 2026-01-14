import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_customer/auth/screens/plandetails_screen.dart';
import 'package:sustajn_customer/auth/screens/termscondition_screen.dart';
import 'package:sustajn_customer/common_widgets/custom_app_bar.dart';
import 'package:sustajn_customer/common_widgets/custom_back_button.dart';
import '../../constants/imports_util.dart';
import '../../constants/network_urls.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../models/subscriptionplan_data.dart';
import '../../network_provider/network_provider.dart';
import '../../provider/signup_provider.dart';
import '../../service/login_service.dart';
import '../../utils/nav_utils.dart';
import '../../utils/utils.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() =>
      _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  int _currentIndex = 0;
  int? _selectedIndex;


  int? get selectedPlanId {
    final plans = ref.read(signUpNotifier).subscriptionList;
    if (plans == null || plans.isEmpty) return null;
    if (_selectedIndex == null) return null;
    if (_selectedIndex! >= plans.length) return null;
    return plans[_selectedIndex!].planId;
  }



  @override
  void initState() {
    super.initState();
    _getNetworkData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final signUpState = ref.watch(signUpNotifier);
    final plans = signUpState.subscriptionList ?? [];
    final carouselHeight = MediaQuery.of(context).size.height * 0.55;


    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: theme.primaryColor,
        appBar: CustomAppBar(
          title: "",
          leading: CustomBackButton(),
        ).getAppBar(context),

        body: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Choose Plan",
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: Constant.SIZE_06),
                      Text(
                        "Select a subscription plan to unlock the functionality of the application",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: Constant.CONTAINER_SIZE_22),

                      if (plans.isEmpty && !signUpState.isLoading)
                        _emptyState(theme)
                      else
                        _plansCarousel(context, theme, plans),

                      SizedBox(height: Constant.CONTAINER_SIZE_20),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final planId = selectedPlanId;
                            if (planId == null) {
                              showCustomSnackBar(
                                context: context,
                                message: "Please select a subscription plan",
                                color: Colors.black,
                              );
                              return;
                            }
                            ref
                                .read(signUpNotifier)
                                .setSubscriptionPlan(planId);
                            NavUtil.navigateWithReplacement(
                              TermsconditionScreen(),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Constant.gold,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                Constant.CONTAINER_SIZE_16,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: Constant.CONTAINER_SIZE_16,
                            ),
                          ),
                          child: Text(
                            "Proceed to Terms & Conditions",
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            if (signUpState.isLoading)
              const Center(child: CircularProgressIndicator(
                color: Constant.gold,
              )),
          ],
        ),
      ),
    );

  }

  Widget _freemiumCard(
      BuildContext context,
      ThemeData theme,
      SubscriptionData plan, {
        required bool isSelected,
      })
  {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(Constant.SIZE_06),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_28),
        border: Border.all(color: Constant.gold.withOpacity(0.6)),
      ),
      child: Container(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_24),
          border: Border.all(color: Constant.gold),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.primaryColor.withOpacity(0.9),
              theme.scaffoldBackgroundColor.withOpacity(0.9),
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: isSelected
                  ? Icon(
                Icons.check_circle,
                color: Constant.gold,
              )
                  : const SizedBox(height: 24),
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_10),
            Icon(
              Icons.percent,
              color: Colors.white,
              size: Constant.CONTAINER_SIZE_60,
            ),
            SizedBox(height: Constant.CONTAINER_SIZE_16),
            Text(
              plan.planName ?? "",
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
              ),
            ),
            SizedBox(height: Constant.SIZE_08),
            Text(
              "₹ ${plan.feeType?.toStringAsFixed(2) ?? "0.00"}",
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Constant.gold,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: Constant.CONTAINER_SIZE_20),
            _featureItem(theme, plan),
            SizedBox(height: Constant.CONTAINER_SIZE_18),
            _learnMoreButton(context, theme, plan),
          ],
        ),
      ),
    );
  }


  Widget _featureItem(ThemeData theme, SubscriptionData data) {
    return Padding(
      padding: EdgeInsets.only(bottom: Constant.SIZE_10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            color: Constant.gold,
            size: Constant.CONTAINER_SIZE_20,
          ),
          SizedBox(width: Constant.SIZE_10),
          Expanded(
            child: Text(
              data.description ?? "",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _plansCarousel(
      BuildContext context,
      ThemeData theme,
      List<SubscriptionData> plans,
      ) {
    final carouselHeight = MediaQuery.of(context).size.height * 0.55;

    return Column(
      children: [
        SizedBox(
          height: carouselHeight,
          child: CarouselSlider(
            options: CarouselOptions(
              height: carouselHeight,
              enlargeCenterPage: true,
              enableInfiniteScroll: false,
              viewportFraction: 0.8,
              onPageChanged: (index, reason) {
                setState(() => _currentIndex = index);
              },
            ),
            items: List.generate(plans.length, (index) {
              final plan = plans[index];
              return GestureDetector(
                onLongPress: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                child: SingleChildScrollView(
                  child: _freemiumCard(
                    context,
                    theme,
                    plan,
                    isSelected: _selectedIndex == index,
                  ),
                ),
              );
            }),
          ),
        ),
        SizedBox(height: Constant.CONTAINER_SIZE_10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(plans.length, (index) {
            final isActive = _currentIndex == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isActive ? 10 : 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: isActive ? Colors.white : Colors.white54,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _emptyState(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Constant.CONTAINER_SIZE_40),
      child: Center(
        child: Text(
          "No subscription plans found",
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Colors.white70,
          ),
        ),
      ),
    );
  }


  Widget _learnMoreButton(BuildContext context, ThemeData theme, SubscriptionData plan) {
    return OutlinedButton(
      onPressed: () {
        ref.read(signUpNotifier).setSubscriptionPlan(plan.planId!);

        NavUtil.navigateToPushScreen(
          context,
          PlandetailsScreen(plan: plan),
        );
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Constant.gold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
        ),
        padding: EdgeInsets.symmetric(
          vertical: Constant.SIZE_10,
          horizontal: Constant.CONTAINER_SIZE_35,
        ),
      ),
      child: Text(
        "Learn More",
        style: theme.textTheme.labelLarge?.copyWith(
          color: Constant.gold,
        ),
      ),
    );
  }

  _getNetworkData() async {
    final registrationState = ref.read(signUpNotifier);
    try {
        await ref
            .read(networkProvider.notifier)
            .isNetworkAvailable()
            .then((isNetworkAvailable) async {
          try {
            if (isNetworkAvailable) {
              registrationState.setIsLoading(true);
              registrationState.setContext(context);
              var url = '${NetworkUrls.GET_SUBSCRIPTION_PLAN}';

              ref.read(getSubscriptionProvider(url));
            } else {
              registrationState.setIsLoading(false);
              if(!mounted) return;
              showCustomSnackBar(context: context, message: Strings.NO_INTERNET_CONNECTION, color: Colors.red);
            }
          } catch (e) {
            Utils.printLog('Error on button onPressed: $e');
            registrationState.setIsLoading(false);
          }
          if(!mounted) return;
          FocusScope.of(context).unfocus();
        });

    } catch (e) {
      Utils.printLog('Error in Login button onPressed: $e');
      registrationState.setIsLoading(false);
    }
  }


}

