import 'package:sustajn_customer/auth/screens/termscondition_screen.dart';
import 'package:sustajn_customer/common_widgets/custom_app_bar.dart';
import 'package:sustajn_customer/common_widgets/custom_back_button.dart';
import 'package:sustajn_customer/utils/nav_utils.dart';

import '../../constants/imports_util.dart';
import '../../constants/number_constants.dart';
import '../../models/subscriptionplan_data.dart';

class PlandetailsScreen extends StatelessWidget {
  final SubscriptionData plan;
  const PlandetailsScreen({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: CustomAppBar(title: 'Plan Details',
          leading: CustomBackButton()).getAppBar(context),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              _freemiumCard(theme),

              SizedBox(height: Constant.CONTAINER_SIZE_24),
              Expanded(
                child: SingleChildScrollView(
                  child: _featureList(theme, plan.description??""),
                ),
              ),

              SizedBox(height: Constant.CONTAINER_SIZE_16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    NavUtil.navigateToPushScreen(context, TermsconditionScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constant.gold,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(Constant.CONTAINER_SIZE_16),
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
    );
  }

  Widget _freemiumCard(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(Constant.SIZE_03),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_28),
        border: Border.all(color: Constant.gold.withOpacity(0.6)),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_24),
          border: Border.all(color: Constant.gold),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.primaryColor.withOpacity(0.9),
              theme.scaffoldBackgroundColor.withOpacity(0.15),
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.percent,
              color: Colors.white,
              size: Constant.CONTAINER_SIZE_40,
            ),

            SizedBox(height: Constant.SIZE_10),

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
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _featureList(ThemeData theme, String description) {
    if (description.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        _featureItem(theme, description),
      ],
    );
  }


  Widget _featureItem(ThemeData theme, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: Constant.CONTAINER_SIZE_10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: Constant.CONTAINER_SIZE_22,
            width: Constant.CONTAINER_SIZE_22,
            decoration: BoxDecoration(
              color: Constant.gold,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              color: theme.primaryColor,
              size: Constant.SIZE_15,
            ),
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
}