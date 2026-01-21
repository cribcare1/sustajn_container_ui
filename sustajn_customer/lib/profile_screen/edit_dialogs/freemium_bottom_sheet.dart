import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_customer/provider/profile_provider.dart';
import '../../constants/imports_util.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../models/get_profile_model.dart';
import '../../models/subscriptionplan_data.dart';
import '../../network_provider/network_provider.dart';
import '../../notifier/subscription_notifier.dart';
import '../../provider/signup_provider.dart';
import '../../provider/subscription_provider.dart';
import '../../utils/utils.dart';

class FreemiumBottomSheet extends ConsumerStatefulWidget {
  final int userID;
  final int planID;
  const FreemiumBottomSheet({super.key,required this.userID,required this.planID});

  @override
  ConsumerState<FreemiumBottomSheet> createState() => _FreemiumBottomSheetState();
}

class _FreemiumBottomSheetState extends ConsumerState<FreemiumBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subScriptionState = ref.watch(subscriptionNotifier);
    final profileState = ref.watch(profileProvider);
    final SubscriptionResponse? plan =
        profileState.profileModel?.data?.subscriptionResponse;


    if (profileState.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: CircularProgressIndicator(color: Constant.gold),
        ),
      );
    }

    if (plan == null) {
      return Padding(
        padding:  EdgeInsets.all(Constant.CONTAINER_SIZE_20),
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

            Flexible(
              child: SingleChildScrollView(
                child: _freemiumCard(theme,plan),
              ),
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_20),
            _upgradeButton(theme, subScriptionState),
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

  Widget _freemiumCard(ThemeData theme,SubscriptionResponse plan) {
    return Container(
      padding: EdgeInsets.all(Constant.SIZE_03),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_24),
        border: Border.all(
          color: Constant.grey.withOpacity(0.5), // OUTER BORDER
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
          border: Border.all(
            color: Constant.gold, // INNER BORDER
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
            _iconSection(theme,plan),
            SizedBox(height: Constant.CONTAINER_SIZE_12),
            _priceSection(theme,plan),
            SizedBox(height: Constant.CONTAINER_SIZE_20),
            _featureList(theme,plan),
            SizedBox(height: Constant.CONTAINER_SIZE_20),
            _learnMoreButton(theme),
          ],
        ),
      ),
    );
  }

  Widget _iconSection(ThemeData theme,SubscriptionResponse plan, ) {
    return Column(
      children: [
        Icon(
          Icons.percent,
          color: Colors.white,
          size: Constant.CONTAINER_SIZE_40,
        ),
        SizedBox(height: Constant.SIZE_10),
        Text(
         plan.planType??'',
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _priceSection(ThemeData theme,SubscriptionResponse plan, ) {
    return Text(
      "₹ ${plan.feeType?.toStringAsFixed(2) ?? "0.00"}",
      style: theme.textTheme.headlineMedium?.copyWith(
        color: Constant.gold,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _featureList(ThemeData theme,SubscriptionResponse plan) {
    return Column(
      children: [
        _featureItem(theme,plan.description??''),
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

  Widget _upgradeButton(ThemeData theme, SubscriptionNotifier state) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: state.isLoading
            ? null
            : () {
          _getNetworkData();
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


  _getNetworkData() async {
    final registrationState = ref.read(subscriptionNotifier);
    try {
      await ref
          .read(networkProvider.notifier)
          .isNetworkAvailable()
          .then((isNetworkAvailable) async {
        try {
          if (isNetworkAvailable) {
            registrationState.setIsLoading(true);
            registrationState.setContext(context);

            ref.read(feedbackProvider({
              "userId": widget.userID,
              // "restaurantId": "2",
              "subscriptionPlanId":widget.planID
            }));
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
