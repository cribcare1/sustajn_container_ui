import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sustajn_customer/auth/dashboard_screen/widgets/header.dart';
import 'package:sustajn_customer/auth/dashboard_screen/widgets/return_card.dart';
import 'package:sustajn_customer/auth/dashboard_screen/widgets/status_row.dart';
import 'package:sustajn_customer/common_widgets/custom_app_bar.dart';
import 'package:sustajn_customer/common_widgets/custom_back_button.dart';
import '../../constants/number_constants.dart';
import '../../utils/theme_utils.dart';

class ProductScreen extends StatelessWidget {
  final VoidCallback onBack;
  const ProductScreen({Key? key, required this.onBack }) : super(key: key);

  List<Map<String, dynamic>> _sampleData() {
    return [
      {'date': '20/11/2025', 'title': 'Dip Cups',
        'sub': 'ST-DC-50 ', 'vol':'50ml', 'qty': 2, 'days': '0 Days Left',
        'badgeColor': Constant.lightPink},
      {'date': '25/11/2025', 'title': 'Dip Cups',
        'sub': 'ST-DC-50 ','vol':'50ml', 'qty': 4, 'days': '1 Days Left',
        'badgeColor': Constant.lightBlue},
      {'date': '27/11/2025', 'title': 'Dip Cups',
        'sub': 'ST-DC-50 ','vol':'50ml', 'qty': 3, 'days': '2 Days Left',
        'badgeColor': Constant.lightGreen},
      {'date': '27/11/2025', 'title': 'Dip Cups',
        'sub': 'ST-DC-50 ','vol':'50ml', 'qty': 3, 'days': '2 Days Left',
        'badgeColor': Constant.lightYellow},
    ];
  }

  @override
  Widget build(BuildContext context) {
    var theme = CustomTheme.getTheme(true);
    return WillPopScope(
      onWillPop: () async {
        onBack();
        return false;
      },
      child: Scaffold(
        backgroundColor:theme!.scaffoldBackgroundColor,
        appBar: CustomAppBar(title: 'Products',
            action: [
              IconButton(onPressed: (){},
                  icon: Icon(Icons.filter_list,
                  color: Colors.white,))
            ],
            leading: CustomBackButton(
              onTap: onBack,
            )).getAppBar(context),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: Constant.CONTAINER_SIZE_24, top: Constant.SIZE_04),
                  itemCount: _sampleData().length,
                  itemBuilder: (context, index) {
                    final item = _sampleData()[index];
                    return ReturnCard(
                      date: item['date'],
                      title: item['title'],
                      subTitle: item['sub'],
                      volume: item['vol'],

                      qty: item['qty'],
                      daysLeft: item['days'],
                      daysBadgeColor: item['badgeColor'],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}