import 'package:flutter/material.dart';

import '../../constants/number_constants.dart';
import '../../utils/theme_utils.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Map<String, List<Map<String, dynamic>>> orders = {
      'December-2025': [
        {
          'title': 'Dip Cups-150',
          'orderId': '#ORD-00234',
          'date': 'Ordered on: 10/12/2025',
          'status': 'Pending',
        },
        {
          'title': 'Round Container-200',
          'orderId': '#ORD-00233',
          'date': 'Confirmed on: 01/12/2025',
          'status': 'Confirmed',
        },
      ],
      'November-2025': [
        {
          'title': 'Round Container-200, Dip Cup-15, ..',
          'orderId': '#ORD-00232',
          'date': 'Delivered on: 26/11/2025',
          'status': 'Delivered',
        },
        {
          'title': 'Rectangular Container-300',
          'orderId': '#ORD-00231',
          'date': 'Rejected on: 10/11/2025',
          'status': 'Rejected',
        },
      ],
    };

    final searchController = TextEditingController();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.all(Constant.CONTAINER_SIZE_16),
          child: Column(
            children: [
              CustomTheme.searchField(searchController, "Search Container by Name"),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: orders.keys.length,
                  itemBuilder: (context, index) {
                    final month = orders.keys.elementAt(index);
                    final monthOrders = orders[month]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMonthHeader(context, month),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: monthOrders.length,
                          separatorBuilder: (_, __) =>
                              SizedBox(height: Constant.CONTAINER_SIZE_12),
                          itemBuilder: (context, orderIndex) {
                            return _buildOrderCard(
                              context,
                              monthOrders[orderIndex],
                            );
                          },
                        ),
                      ],
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

  // 🔍 Search Bar
  Widget _buildSearchBar(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search by Container Name',
          prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
          suffixIcon: Icon(Icons.tune, color: theme.iconTheme.color),
          filled: true,
          fillColor: theme.cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // 🗓 Month Header
  Widget _buildMonthHeader(BuildContext context, String title) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Constant.CONTAINER_SIZE_16,
        vertical: Constant.SIZE_08,
      ),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: Colors.white
        ),
      ),
    );
  }

  // 📦 Order Card
  Widget _buildOrderCard(
      BuildContext context,
      Map<String, dynamic> order,
      ) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
      decoration: BoxDecoration(
        color: Constant.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
        border: Border.all(
          color: Constant.grey.withOpacity(0.2)
        )
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildOrderDetails(context, order)),
          SizedBox(width: Constant.CONTAINER_SIZE_12),
          _buildStatusChip(context, order['status']),
        ],
      ),
    );
  }

  Widget _buildOrderDetails(
      BuildContext context,
      Map<String, dynamic> order,
      ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          order['title'],
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: Constant.SIZE_04),
        Text(
          'Order ID: ${order['orderId']}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.white
          ),
        ),
        SizedBox(height: Constant.SIZE_04),
        Text(
          order['date'],
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.white
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(BuildContext context, String status) {
    final theme = Theme.of(context);

    Color background;
    Color textColor;

    switch (status) {
      case 'Pending':
        background = Constant.lightYellow;
        textColor = Colors.black;
        break;
      case 'Confirmed':
        background = Constant.lightGreen;
        textColor = Colors.black;
        break;
      case 'Delivered':
        background = Constant.lightBlue;
        textColor = Colors.black;
        break;
      default:
        background = Constant.lightPink;
        textColor = Colors.black;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Constant.CONTAINER_SIZE_12,
        vertical: Constant.SIZE_06,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
      ),
      child: Text(
        status,
        style: theme.textTheme.labelSmall?.copyWith(color: textColor),
      ),
    );
  }
}
