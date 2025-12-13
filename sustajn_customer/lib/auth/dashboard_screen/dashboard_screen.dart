import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sustajn_customer/auth/dashboard_screen/widgets/header.dart';
import 'package:sustajn_customer/auth/dashboard_screen/widgets/return_card.dart';
import 'package:sustajn_customer/auth/dashboard_screen/widgets/status_row.dart';
import '../../constants/number_constants.dart';

class ContainerReturnScreen extends StatelessWidget {
  const ContainerReturnScreen({Key? key}) : super(key: key);

  List<Map<String, dynamic>> _sampleData() {
    return [
      {'date': '20/11/2025', 'title': 'Dip Cups', 'sub': 'ST-DC-50 ', 'vol':'50ml', 'qty': 2, 'days': '0 Days Left', 'badgeColor': Constant.badgePink},
      {'date': '25/11/2025', 'title': 'Dip Cups', 'sub': 'ST-DC-50 ','vol':'50ml', 'qty': 4, 'days': '1 Days Left', 'badgeColor': Constant.orangeCircle},
      {'date': '27/11/2025', 'title': 'Dip Cups', 'sub': 'ST-DC-50 ','vol':'50ml', 'qty': 3, 'days': '2 Days Left', 'badgeColor': Constant.statusUpcoming},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.background,
      body: SafeArea(
        child: Column(
          children: [
            HeaderWidget(name: 'John Dee'),
            SizedBox(height: Constant.SIZE_08),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Container Return Status',
                      style: Theme.of(context).textTheme.titleLarge?.
                      copyWith(color: Constant.profileText,
                          fontSize: Constant.LABEL_TEXT_SIZE_20, fontWeight: FontWeight.w700)),
                  SizedBox.shrink(),
                ],
              ),
            ),
            SizedBox(height: Constant.CONTAINER_SIZE_12),

            StatusRow(),

            Padding(
              padding:  EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_16, vertical: Constant.SIZE_06),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Container Returns List', style: Theme.of(context).textTheme.titleMedium?.
                  copyWith(color: Constant.profileText, fontSize: Constant.LABEL_TEXT_SIZE_18,
                      fontWeight: FontWeight.w600)),
                  Text('View All', style: Theme.of(context).textTheme.bodySmall?.copyWith
                    (color: Constant.statusUpcoming, fontSize: Constant.LABEL_TEXT_SIZE_14)),
                ],
              ),
            ),

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
    );
  }
}