import 'package:container_tracking/common_widgets/custom_app_bar.dart';
import 'package:container_tracking/common_widgets/custom_back_button.dart';
import 'package:container_tracking/constants/number_constants.dart';
import 'package:flutter/material.dart';

import '../../constants/string_utils.dart';
import '../../resutants/screens/container_count_details.dart';
import '../../resutants/screens/resturant_transaction_history.dart';
import '../../resutants/screens/transaction_details_bottomsheet.dart';

class CustomerDetailsScreen extends StatefulWidget {
  const CustomerDetailsScreen({super.key});

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  final List<Map<String, dynamic>> containerCards = [
    {'title': "Total Borrowed", 'value': 2343},
    {'title': "Total Returned", 'value': 1354},
    {'title': "Total Pending", 'value': 1543},
    {'title': "Overdue", 'value': 234},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Customer Details",
        leading: CustomBackButton(),
      ).getAppBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
        child: Column(
          children: [
            SizedBox(height: Constant.CONTAINER_SIZE_12),
            GridView.builder(
              padding: EdgeInsets.all(0),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: containerCards.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.6,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ContainerCountDetails(
                          title: containerCards[index]['title'],
                        ),
                      ),
                    );
                  },
                  child: _buildContainersInfo(context, containerCards[index]),
                );
              },
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_16),
            buildTransactionHistory(context),
          ],
        ),
      ),
    );
  }

  Widget _buildContainersInfo(BuildContext context, Map<String, dynamic> item) {
    return Container(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(Constant.SIZE_08),
        color: Colors.white
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item['title'],
            style: TextStyle(
              fontSize: Constant.CONTAINER_SIZE_14,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: Constant.SIZE_04),
          Text(
            item['value'].toString(),
            style: TextStyle(
              fontSize: Constant.CONTAINER_SIZE_18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTransactionHistory(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              Strings.TRANSACTION_HISTORY,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RestaurantTransactionHistoryScreen(),
                  ),
                );
              },
              child: Text(
                Strings.VIEW_ALL,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.green,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.green,
                  decorationThickness: 1.5,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_10),
            color: Colors.white
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding:  EdgeInsets.all(Constant.SIZE_06),
            itemCount: transactions.length,
            separatorBuilder: (context, index) =>
                Divider(color: Colors.grey.shade300),
            itemBuilder: (context, index) {
              final item = transactions[index];
              return InkWell(
                onTap: () {
                  showTransactionDetailsBottomSheet(
                    context,
                    status: item.status,
                    requestedDate: "20/11/2025",
                    approvedDate: "21/11/2025",
                    large: 50,
                    medium: 30,
                    small: 20,
                    count: int.parse(item.count),
                  );
                },
                child: buildHistoryItem(item),
              );
            },
          ),
        ),
      ],
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

  final List<TransactionItem> transactions = [
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
