import 'package:sustajn_customer/auth/screens/plandetails_screen.dart';

import '../../constants/imports_util.dart';
import '../../constants/number_constants.dart';
import '../../utils/nav_utils.dart';

class SubscriptinonScreen extends StatelessWidget {
  const SubscriptinonScreen({super.key});

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

              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: Constant.CONTAINER_SIZE_26,
                ),
                onPressed: () => Navigator.pop(context),
              ),

              SizedBox(height: Constant.CONTAINER_SIZE_10),

              Text(
                "Choose Plan",
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: Constant.SIZE_06),

              Text(
                "Select a subscription plan to unlock the functionality\nof the application",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
              ),

              SizedBox(height: Constant.CONTAINER_SIZE_22),

              Expanded(
                child: Center(
                  child: _freemiumCard(context, theme),
                ),
              ),

              SizedBox(height: Constant.CONTAINER_SIZE_10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: Constant.SIZE_08,
                    width: Constant.CONTAINER_SIZE_28,
                    decoration: BoxDecoration(
                      color: Constant.gold,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    height: Constant.SIZE_08,
                    width: Constant.SIZE_08,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),

              SizedBox(height: Constant.CONTAINER_SIZE_20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
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

  Widget _freemiumCard(BuildContext context, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(Constant.SIZE_03),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_28),
        border: Border.all(color: Constant.gold.withOpacity(0.6)),
      ),
      child: Container(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_24),
          border: Border.all(color: Constant.gold),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.primaryColor.withOpacity(0.9),
              theme.scaffoldBackgroundColor.withOpacity(0.25),
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // Tick icon top-right
            Align(
              alignment: Alignment.topRight,
              child: Icon(
                Icons.check_circle,
                color: Constant.white,
              ),
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_10),

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
              "₹ 0.00",
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Constant.gold,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_20),

            _featureList(theme),

            SizedBox(height: Constant.CONTAINER_SIZE_18),

            _learnMoreButton(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _featureList(ThemeData theme) {
    return Column(
      children: [
        _featureItem(
          theme,
          "Lorem ipsum dolor sit amet consectetur.\n"
              "Vel ac nunc tempus ornare neque odio massa in quis.",
        ),
        _featureItem(theme, "Lorem ipsum dolor sit amet consectetur."),
        _featureItem(theme, "Lorem ipsum dolor sit amet consectetur."),
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

  Widget _learnMoreButton(BuildContext context, ThemeData theme) {
    return OutlinedButton(
      onPressed: () {
        NavUtil.navigateToPushScreen(context, PlandetailsScreen());
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
}