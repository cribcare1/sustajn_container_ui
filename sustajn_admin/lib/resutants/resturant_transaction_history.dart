import 'package:container_tracking/resutants/transaction_card.dart';
import 'package:flutter/material.dart';

import '../common_widgets/custom_app_bar.dart';
import '../common_widgets/custom_back_button.dart';
import '../constants/number_constants.dart';
import '../constants/string_utils.dart';
import 'models/transaction_record.dart';

class RestaurantTransactionHistoryScreen extends StatefulWidget {
  const RestaurantTransactionHistoryScreen({super.key});

  @override
  State<RestaurantTransactionHistoryScreen> createState() =>
      _RestaurantTransactionHistoryScreenState();
}

class _RestaurantTransactionHistoryScreenState
    extends State<RestaurantTransactionHistoryScreen> {
  String selectedStatus = "Status";
  String selectedMonth = "Month";

  List<TransactionRecord> transactions = [
    TransactionRecord(
      status: "Pending",
      amount: 50,
      date: DateTime(2025, 11, 20),
    ),
    TransactionRecord(
      status: "Approved",
      amount: 100,
      date: DateTime(2025, 10, 1),
    ),
    TransactionRecord(
      status: "Rejected",
      amount: 500,
      date: DateTime(2025, 9, 9),
    ),
    TransactionRecord(
      status: "Approved",
      amount: 1000,
      date: DateTime(2025, 8, 10),
    ),
    TransactionRecord(
      status: "Approved",
      amount: 400,
      date: DateTime(2025, 8, 29),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: CustomAppBar(
        title: Strings.RESTURANT_TRANSACTION_HISTORY_TITLE,
        leading: CustomBackButton(),
      ).getAppBar(context),

      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: Constant.CONTAINER_SIZE_12,
          horizontal: Constant.CONTAINER_SIZE_12,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedStatus,
                    items:
                        [
                              Strings.STATUS,
                              Strings.APPROVED_STATUS,
                              Strings.REJECTED_STATUS,
                              Strings.PENDING_STATUS,
                            ]
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                    onChanged: (v) => setState(() => selectedStatus = v!),
                    decoration: InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: Constant.SIZE_08),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedMonth,
                    items:
                        [
                              "Month",
                              "January",
                              "February",
                              "March",
                              "April",
                              "May",
                              "June",
                              "July",
                              "August",
                              "September",
                              "October",
                              "November",
                              "December",
                            ]
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                    onChanged: (v) => setState(() => selectedMonth = v!),
                    decoration: InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_12),

            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: transactions.length,
                separatorBuilder: (_, __) => Divider(height: 0.4),
                itemBuilder: (context, index) {
                  return TransactionItemCard(data: transactions[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
