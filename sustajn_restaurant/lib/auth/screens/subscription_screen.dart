import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../common_widgets/lottie_animation_screen.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import 'dashboard_screen.dart';



class SubscriptionScreen extends StatefulWidget {
  final int currentStep;
  const SubscriptionScreen({Key? key, this.currentStep=3}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {

  bool isMonthly = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final media = MediaQuery.of(context);
    final width = media.size.width;
    final height = media.size.height;

    final horizontalPadding = width * 0.06;


    final popularPrice = isMonthly ? '₹500/month' : '₹500/year';
    final payPerUsePrice = isMonthly ? '₹1000/month' : '₹1000/year';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Constant.bgLight,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: Constant.PADDING_HEIGHT_10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top + Constant.CONTAINER_SIZE_70),
                Row(
                  children: List.generate(4, (index) {
                    bool active = index <= widget.currentStep;
                    return Expanded(
                      child: Container(
                        height: Constant.SIZE_05,
                        margin: EdgeInsets.only(right: index == 3 ? 0 : Constant.SIZE_10),
                        decoration: BoxDecoration(
                          color: active
                              ? theme.primaryColor
                              : theme.primaryColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(Constant.SIZE_10),
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: Constant.CONTAINER_SIZE_20),
                Text(
                  Strings.CHOOSE_PLAN,
                  style: theme.textTheme.titleLarge!.copyWith(
                    color: Colors.black,
                    fontSize: Constant.LABEL_TEXT_SIZE_24,
                  ),
                ),
                SizedBox(height: Constant.PADDING_HEIGHT_10),
                Text(
                  Strings.SELECT_PLAN,
                  style: theme.textTheme.titleMedium!.copyWith(
                    color:Constant.textGrey,
                    fontSize: Constant.LABEL_TEXT_SIZE_14,
                  ),
                ),
                SizedBox(height: Constant.CONTAINER_SIZE_20),

                _buildToggle(width),
                SizedBox(height: Constant.CONTAINER_SIZE_40),

                _buildPopularCard(width, popularPrice),
                SizedBox(height: Constant.CONTAINER_SIZE_40),

                _buildPayPerUseCard(width, payPerUsePrice),
                SizedBox(height: height * 0.12),

                _buildSubscribeButton(width, theme),
                SizedBox(height: Constant.CONTAINER_SIZE_20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggle(double fullWidth) {

    final double toggleHeight = Constant.CONTAINER_SIZE_44;
    final double toggleWidth = fullWidth * 0.9;
    final double thumbWidth = (toggleWidth / 2) - 8;

    return Center(
      child: Container(
        width: toggleWidth,
        height: toggleHeight,
        padding:  EdgeInsets.all(Constant.SIZE_04),
        decoration: BoxDecoration(
          color: Constant.bgTint,
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_50),
        ),
        child: Stack(
          children: [

            AnimatedPositioned(
              left: isMonthly ? 4 : (toggleWidth / 2) + 0,
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 220),
              child: GestureDetector(
                onTap: () => setState(() => isMonthly = !isMonthly),
                child: Container(
                  width: thumbWidth,
                  height: toggleHeight - 8,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: Text(
                    isMonthly ? Strings.MONTHLY : Strings.YEARLY,
                    style: TextStyle(
                      color: Constant.cardDarkGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            Positioned.fill(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => isMonthly = true),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          Strings.MONTHLY,
                          style: TextStyle(
                            color: isMonthly ? Colors.transparent : Constant.cardDarkGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => isMonthly = false),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          Strings.YEARLY,
                          style: TextStyle(
                            color: isMonthly ? Constant.cardDarkGreen : Colors.transparent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularCard(double width, String priceText) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: Constant.CONTAINER_SIZE_22,
            vertical: Constant.CONTAINER_SIZE_20,
          ),
          decoration: BoxDecoration(
            color: Constant.cardDarkGreen,
            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_14),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Strings.POPULAR,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Constant.LABEL_TEXT_SIZE_20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Container(
                    width: Constant.CONTAINER_SIZE_24,
                    height: Constant.CONTAINER_SIZE_24,
                    decoration: BoxDecoration(
                      color: Colors.white30,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.2),
                    ),
                    child:  Icon(Icons.check, size: Constant.CONTAINER_SIZE_16, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_12),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _featureRow('Real-time menu updates for customers'),
                  SizedBox(height: Constant.SIZE_06),
                  _featureRow('Faster order processing for your staff'),
                  SizedBox(height: Constant.SIZE_06),
                  _featureRow('Easy tracking of daily earnings'),
                ],
              ),
            ],
          ),
        ),

        Positioned(
          right: -6,
          top: -14,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_12, vertical: Constant.SIZE_06),
            decoration: BoxDecoration(
              color: Constant.tagYellow,
              borderRadius: BorderRadius.circular(Constant.SIZE_08),
              border: Border.all(color: Constant.borderLight),
            ),
            child: Text(
              priceText,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPayPerUseCard(double width, String priceText) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: Constant.CONTAINER_SIZE_22,
            vertical: Constant.CONTAINER_SIZE_20,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_14),
            border: Border.all(color: Constant.borderLight, width: 1.8),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: Constant.SIZE_06, offset: Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Strings.PAY_PER_USE,
                style: TextStyle(
                  color: Constant.cardDarkGreen,
                  fontSize: Constant.LABEL_TEXT_SIZE_18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_12),
              _featureRowDark('Secure digital payments for all orders '),
              SizedBox(height: Constant.SIZE_06),
              _featureRowDark('Instant alerts for new bookings'),
              SizedBox(height: Constant.SIZE_06),
              _featureRowDark('24×7 support for all restaurant partners'),
            ],
          ),
        ),

        Positioned(
          right: -6,
          top: -14,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_12, vertical: Constant.SIZE_06),
            decoration: BoxDecoration(
              color: Constant.tagYellow,
              borderRadius: BorderRadius.circular(Constant.SIZE_08),
              border: Border.all(color: Constant.borderLight),
            ),
            child: Text(
              priceText,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _featureRow(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Icon(Icons.check, size: Constant.CONTAINER_SIZE_16, color: Color(0xFFD0A52C)),
        SizedBox(width: Constant.CONTAINER_SIZE_10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _featureRowDark(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check, size: Constant.CONTAINER_SIZE_16, color: Constant.cardDarkGreen),
        SizedBox(width: Constant.CONTAINER_SIZE_10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildSubscribeButton(double width, ThemeData theme) {
    return  SizedBox(
      width: double.infinity,
      height: Constant.CONTAINER_SIZE_48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD0A52C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Constant.SIZE_10),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LottieMessageScreen(
                animation: 'assets/animations/animation.json',
                title: "Subscription Successful!",
                subtitle: "Thank you for subscribing.Your account is now active",
                nextScreen: const DashboardScreen(),
              ),
            ),
          );
        },

        child: Text(
          Strings.SUBSCRIBE,
          style: theme.textTheme.titleMedium!.copyWith(
            color: theme.primaryColor,
          ),
        ),
      ),
    );

  }
}