import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_customer/auth/screens/plandetails_screen.dart';
import 'package:sustajn_customer/auth/screens/termscondition_screen.dart';
import 'package:sustajn_customer/common_widgets/custom_app_bar.dart';
import 'package:sustajn_customer/common_widgets/custom_back_button.dart';
import '../../constants/imports_util.dart';
import '../../constants/number_constants.dart';
import '../../utils/nav_utils.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() =>
      _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  int _currentIndex = 0;

  final List<String> imgList = [
    '', // add actual images if needed
    '',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final carouselHeight = MediaQuery.of(context).size.height * 0.55;

    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar:
      CustomAppBar(title: "", leading: CustomBackButton()).getAppBar(context),
      body: SafeArea(
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

                // ---------- Carousel ----------
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
                    items: imgList.map((item) {
                      return SingleChildScrollView(child: _freemiumCard(context, theme));
                    }).toList(),
                  ),
                ),

                SizedBox(height: Constant.CONTAINER_SIZE_10),

                // ---------- Dots ----------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: imgList.asMap().entries.map((entry) {
                    final isActive = _currentIndex == entry.key;
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
                  }).toList(),
                ),

                SizedBox(height: Constant.CONTAINER_SIZE_20),

                // ---------- Proceed Button ----------
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
      ),
    );
  }

  // ---------- Freemium Card ----------
  Widget _freemiumCard(BuildContext context, ThemeData theme) {
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
              child: Icon(
                Icons.check_circle,
                color: Constant.white,
              ),
            ),
            SizedBox(height: Constant.CONTAINER_SIZE_10),
            Icon(
              Icons.percent,
              color: Colors.white,
              size: Constant.CONTAINER_SIZE_60,
            ),
            SizedBox(height: Constant.CONTAINER_SIZE_16),
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
          "Lorem ipsum dolor sit amet consectetur.\nVel ac nunc tempus ornare neque odio massa in quis.",
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
