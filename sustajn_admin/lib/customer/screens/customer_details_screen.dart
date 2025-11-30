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
                crossAxisCount: 2,
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
            _buildRestaurantHistory(context)
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
  Widget _buildRestaurantHistory(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              Strings.RESTURANT_HISTORY,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: Constant.LABEL_TEXT_SIZE_18,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                print('on tap called');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RestaurantTransactionHistoryScreen(),
                  ),
                );
              },
              child: Text(
                Strings.VIEW_ALL,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: Constant.LABEL_TEXT_SIZE_14,
                  color: Color(0xFF8daba0),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: Constant.CONTAINER_SIZE_16),

        _buildHistoryRow(
          context,
          title: "Requested on",
          date: "20/11/2025",
          count: "50",
          status: "Pending",
          statusColor: Color(0xFFfadb7f),
        ),

        Divider(
          color: Colors.grey.shade300,
          height: Constant.CONTAINER_SIZE_24,
        ),

        _buildHistoryRow(
          context,
          title: "Approved on",
          date: "01/10/2025",
          count: "100",
          status: "Approved",
          statusColor: Color(0xFF75c487),
        ),

        Divider(
          color: Colors.grey.shade300,
          height: Constant.CONTAINER_SIZE_24,
        ),

        _buildHistoryRow(
          context,
          title: "Rejected on",
          date: "09/09/2025",
          count: "500",
          status: "Rejected",
          statusColor: Color(0xFFe26571),
        ),
      ],
    );
  }
  Widget _buildHistoryRow(
      BuildContext context, {
        required String title,
        required String date,
        required String count,
        required String status,
        required Color statusColor,
      }) {
    return GestureDetector(
      onTap: () {
        showTransactionDetailsBottomSheet(
          context,
          status: status,
          requestedDate: "20/11/2025",
          approvedDate: "21/11/2025",
          large: 50,
          medium: 30,
          small: 20,
          count: int.parse(count),
        );
      },

      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: Constant.LABEL_TEXT_SIZE_14,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: Constant.SIZE_04),
                Text(
                  date,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: Constant.LABEL_TEXT_SIZE_14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                count,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: Constant.LABEL_TEXT_SIZE_16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: Constant.SIZE_04),
              Text(
                status,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: Constant.CONTAINER_SIZE_12,
                  color: statusColor,
                ),
              ),
            ],
          ),

          SizedBox(width: Constant.SIZE_08),
          Icon(
            Icons.chevron_right,
            size: Constant.CONTAINER_SIZE_20,
            color: Colors.grey.shade500,
          ),
        ],
      ),
    );
  }
}
