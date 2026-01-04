import 'package:sustajn_customer/auth/screens/termscondition_screen.dart';
import 'package:sustajn_customer/utils/nav_utils.dart';

import '../../constants/imports_util.dart';
import '../../constants/number_constants.dart';

class PlandetailsScreen extends StatelessWidget {
  const PlandetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: Constant.CONTAINER_SIZE_26,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(width: Constant.SIZE_06),
                  Text(
                    "Plan Details",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              SizedBox(height: Constant.CONTAINER_SIZE_22),

              _freemiumCard(theme),

              SizedBox(height: Constant.CONTAINER_SIZE_24),
              Expanded(
                child: SingleChildScrollView(
                  child: _featureList(theme),
                ),
              ),

              SizedBox(height: Constant.CONTAINER_SIZE_16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=> TermsconditionScreen()));
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
              "Freemium",
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
              ),
            ),

            SizedBox(height: Constant.SIZE_08),

            Text(
              "₹0.00",
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
  Widget _featureList(ThemeData theme) {
    final features = [
      "Lorem ipsum dolor sit amet consectetur. Vel ac nunc tempus ornare neque odio massa in quis.",
      "Lorem ipsum dolor sit amet consectetur.",
      "Lorem Ipsum",
      "Lorem ipsum dolor sit amet consectetur. Vitae eu",
      "Lorem Ipsum",
      "Lorem ipsum dolor sit amet consectetur. Vitae eu",
    ];

    return Column(
      children: features
          .map((e) => _featureItem(theme, e))
          .toList(growable: false),
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