import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/imports_util.dart';
import '../../constants/network_urls.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../models/subscriptionplan_data.dart';
import '../../network_provider/network_provider.dart';
import '../../notifier/subscription_notifier.dart';
import '../../provider/profile_provider.dart';
import '../../provider/signup_provider.dart';
import '../../provider/subscription_provider.dart';
import '../../utils/utils.dart';

class FreemiumBottomSheet extends ConsumerStatefulWidget {
  final int userID;
  const FreemiumBottomSheet({super.key, required this.userID});

  @override
  ConsumerState<FreemiumBottomSheet> createState() =>
      _FreemiumBottomSheetState();
}

class _FreemiumBottomSheetState
    extends ConsumerState<FreemiumBottomSheet> {
  int selectedIndex = 0;
  final PageController _pageController =
  PageController(viewportFraction: 0.9);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subscriptionState = ref.watch(signUpNotifier);
    final upgradeState = ref.watch(subscriptionNotifier);

    final List<SubscriptionData> plans =
        subscriptionState.data ?? [];

    final screenHeight = MediaQuery.of(context).size.height;
    final carouselHeight =
    (screenHeight * 0.45).clamp(250.0, 420.0);

    if (subscriptionState.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: CircularProgressIndicator(color: Constant.gold),
        ),
      );
    }

    if (plans.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
        child: Text(
          Strings.NO_SUBSCRIPTION_TEXT,
          style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
        ),
      );
    }

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _header(context),
            SizedBox(height: Constant.CONTAINER_SIZE_20),

            // RESPONSIVE CAROUSEL
            SizedBox(
              height: carouselHeight,
              child: PageView.builder(
                controller: _pageController,
                itemCount: plans.length,
                onPageChanged: (index) {
                  setState(() => selectedIndex = index);
                },
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedIndex = index);
                    },
                    child: _freemiumCard(
                      theme,
                      plans[index],
                      isSelected: index == selectedIndex,
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_20),
            _upgradeButton(
              theme,
              upgradeState,
              plans[selectedIndex].planId!,
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        icon: Icon(
          Icons.close,
          color: Colors.white,
          size: Constant.CONTAINER_SIZE_24,
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _freemiumCard(
      ThemeData theme,
      SubscriptionData plan, {
        required bool isSelected,
      }) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(Constant.SIZE_03),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_24),
            border: Border.all(
              color: Constant.grey.withOpacity(0.5),
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
              border: Border.all(
                color: Constant.gold,
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.primaryColor.withOpacity(0.9),
                  theme.scaffoldBackgroundColor,
                ],
              ),
            ),
            child: Column(
              children: [
                _iconSection(theme, plan),
                SizedBox(height: Constant.CONTAINER_SIZE_12),
                _priceSection(theme, plan),
                SizedBox(height: Constant.CONTAINER_SIZE_20),
                _featureList(theme, plan),
                SizedBox(height: Constant.CONTAINER_SIZE_20),
                _learnMoreButton(theme),
              ],
            ),
          ),
        ),

        // SELECTION ICON
        Positioned(
          top: 10,
          right: 16,
          child: Icon(
            Icons.check_circle,
            color: isSelected ? Constant.gold : Constant.grey,
            size: Constant.CONTAINER_SIZE_26,
          ),
        ),
      ],
    );
  }


  Widget _iconSection(ThemeData theme, SubscriptionData plan) {
    return Column(
      children: [
        Icon(
          Icons.percent,
          color: Colors.white,
          size: Constant.CONTAINER_SIZE_40,
        ),
        SizedBox(height: Constant.SIZE_10),
        Text(
          plan.planType ?? '',
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _priceSection(ThemeData theme, SubscriptionData plan) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/diarhm.png',
          height: Constant.CONTAINER_SIZE_20,
          color: Constant.gold,
          colorBlendMode: BlendMode.srcIn,
        ),
        Text(
          plan.feeType?.toStringAsFixed(2) ?? "0.00",
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Constant.gold,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _featureList(ThemeData theme, SubscriptionData plan) {
    return Column(
      children: [
        _featureItem(theme, plan.description ?? ''),
      ],
    );
  }

  Widget _featureItem(ThemeData theme, String text) {
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
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _learnMoreButton(ThemeData theme) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Constant.gold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
        ),
        padding: EdgeInsets.symmetric(
          vertical: Constant.SIZE_10,
          horizontal: Constant.CONTAINER_SIZE_30,
        ),
      ),
      child: Text(
        Strings.LEARN_MORE,
        style: theme.textTheme.labelLarge?.copyWith(
          color: Constant.gold,
        ),
      ),
    );
  }

  Widget _upgradeButton(
      ThemeData theme,
      SubscriptionNotifier state,
      int planId,
      ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: state.isLoading
            ? null
            : () {
          _getNetworkData(planId);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Constant.gold,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
          ),
          padding: EdgeInsets.symmetric(
            vertical: Constant.CONTAINER_SIZE_14,
          ),
        ),
        child: state.isLoading
            ? const SizedBox(
          height: 22,
          width: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : Text(
          Strings.UPGRADE,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.primaryColor,
          ),
        ),
      ),
    );
  }

  _getNetworkData(int planId) async {
    final registrationState = ref.read(subscriptionNotifier);
    try {
      await ref
          .read(networkProvider.notifier)
          .isNetworkAvailable()
          .then((isNetworkAvailable) async {
        if (isNetworkAvailable) {
          registrationState.setIsLoading(true);
          registrationState.setContext(context);

          await ref.read(feedbackProvider({
            "userId": widget.userID,
            "subscriptionPlanId": planId
          }).future);

          await ref.read(
            getProfileProvider(
              '${NetworkUrls.GET_PROFILE}${widget.userID}',
            ).future,
          );
        } else {
          registrationState.setIsLoading(false);
          showCustomSnackBar(
            context: context,
            message: Strings.NO_INTERNET_CONNECTION,
            color: Colors.red,
          );
        }
      });
    } catch (e) {
      Utils.printLog('Upgrade error: $e');
      registrationState.setIsLoading(false);
    }
  }
}
