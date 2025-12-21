import 'package:flutter/material.dart';

import '../../common_widgets/custom_app_bar.dart';
import '../../common_widgets/custom_back_button.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../models/transaction_record.dart';


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
                    style: Theme.of(context).textTheme.titleSmall,
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
                    style: Theme.of(context).textTheme.titleSmall,
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
                itemCount: transactionsList.length,
                separatorBuilder: (_, __) => Padding(
                  padding:  EdgeInsets.symmetric(vertical: Constant.SIZE_06),
                  child: Divider(height: 0.4,color: Colors.grey.shade300,),
                ),
                itemBuilder: (context, index) {
                  return buildHistoryItem( transactionsList[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget buildHistoryItem(TransactionItem item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(item.icon, size: 18, color: item.iconColor),

        SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.status,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              SizedBox(height: 4),
              Text(
                item.restaurant,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 4),
              Text(
                item.date,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              item.count,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),

        SizedBox(width: 8),
        Icon(Icons.chevron_right, size: 22, color: Colors.grey),
      ],
    );
  }
  final List<TransactionItem> transactionsList = [
    TransactionItem(
      icon: Icons.call_made,
      iconColor: Colors.grey,
      status: "Borrowed",
      restaurant: "Marina Sky Dine",
      date: "21/11/2025",
      count: "3",
    ),
    TransactionItem(
      icon: Icons.call_received,
      iconColor: Colors.green,
      status: "Returned",
      restaurant: "Marina Sky Dine",
      date: "21/11/2025",
      count: "6",
    ),
    TransactionItem(
      icon: Icons.call_made,
      iconColor: Colors.grey,
      status: "Borrowed",
      restaurant: "Marina Sky Dine",
      date: "20/11/2025",
      count: "3",
    ),
    TransactionItem(
      icon: Icons.call_made,
      iconColor: Colors.grey,
      status: "Borrowed",
      restaurant: "Marina Sky Dine",
      date: "18/11/2025",
      count: "3",
    ),
  ];
}
class TransactionItem {
  final IconData icon;
  final Color iconColor;
  final String status;
  final String restaurant;
  final String date;
  final String count;

  TransactionItem({
    required this.icon,
    required this.iconColor,
    required this.status,
    required this.restaurant,
    required this.date,
    required this.count,
  });
}