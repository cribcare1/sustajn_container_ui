import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sustajn_customer/auth/dashboard_screen/widgets/header.dart';
import 'package:sustajn_customer/auth/dashboard_screen/widgets/return_card.dart';
import 'package:sustajn_customer/auth/dashboard_screen/widgets/status_row.dart';
import 'package:sustajn_customer/common_widgets/custom_app_bar.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../utils/theme_utils.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    var theme = CustomTheme.getTheme(true);
    return Scaffold(
      backgroundColor:theme!.scaffoldBackgroundColor ,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              HeaderWidget(name: 'John Dee'),
              SizedBox(height: Constant.SIZE_08),
              Image.asset('assets/images/img_1.png',
              height: Constant.CONATAINER_SIZE_380,
              width: Constant.CONATAINER_SIZE_380,),
              Text(Strings.DASHBOARD_TEXT,
              style: theme.textTheme.titleLarge?.copyWith(
                color: Constant.gold
              ),),
              SizedBox(height: Constant.CONTAINER_SIZE_12,),
              Text(Strings.BORROW_REUSABLE_CONTAINERS,
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white
              ),)
          
            ],
          ),
        ),
      ),
    );
  }
}