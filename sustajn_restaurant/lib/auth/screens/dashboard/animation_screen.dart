import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sustajn_restaurant/auth/screens/dashboard/dashboard_screen.dart';
import 'package:sustajn_restaurant/utils/sharedpreference_utils.dart';

import '../../../constants/number_constants.dart';
import '../../../constants/string_utils.dart';
import '../../../utils/nav_utils.dart';
import '../../../utils/utility.dart';

class AccountSuccessScreen extends StatefulWidget {
  const AccountSuccessScreen({super.key});

  @override
  State<AccountSuccessScreen> createState() => _AccountSuccessScreenState();
}

class _AccountSuccessScreenState extends State<AccountSuccessScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserId();
    });
  }

  Future<void> _loadUserId() async {
    Utils.getProfile();
    Utils.userId = await SharedPreferenceUtils.getIntValuesSF(
      Strings.USER_ID,
    );
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted || Utils.userId == null || Utils.userId == -1) return;
    NavUtil.navigationToWithReplacement(context,
        DashboardScreen());
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Lottie.asset(
                'assets/animations/lottie_animation.json',
                height: Constant.CONTAINER_SIZE_160,
                repeat: false,
              ),

              SizedBox(height: Constant.CONTAINER_SIZE_20),

              Text(
                Strings.ACCOUNT_CREATED_SUCCESSFULLY,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
