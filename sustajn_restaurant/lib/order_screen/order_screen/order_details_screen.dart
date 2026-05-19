import 'package:flutter/material.dart';
import 'package:sustajn_restaurant/common_widgets/custom_app_bar.dart';
import 'package:sustajn_restaurant/common_widgets/custom_back_button.dart';
import '../../constants/number_constants.dart';
import '../../models/container_history_data.dart';
import '../../utils/utility.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;
  final String status;
final  OrderedResponses orderData;
  const OrderDetailsScreen({
    super.key,
    required this.orderId,
    required this.status, required this.orderData,
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(title: 'Order Details',
          leading: CustomBackButton()).getAppBar(context),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              SizedBox(height: Constant.CONTAINER_SIZE_16),

              Row(
                children: [
                  Icon(Icons.badge_outlined,
                      color: Colors.white70,
                      size: Constant.CONTAINER_SIZE_18),
                  SizedBox(width: Constant.SIZE_08),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Order ID",
                          style: TextStyle(color: Colors.white70)),
                      Text(
                        "#${widget.orderId}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: Constant.CONTAINER_SIZE_16),

              _timelineCard(),

              SizedBox(height: Constant.CONTAINER_SIZE_16),

              if (widget.status == "Rejected") ...[
                Text(
                  "Sustajn Remarks",
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: Constant.SIZE_08),
                Text(
                  "Lorem ipsum dolor sit amet consectetur. Nulla magna...",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: Constant.CONTAINER_SIZE_16),
              ],

              Row(
                children: [
                  Text(
                    "Ordered Containers",
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.amber.withOpacity(0.7),
                    ),
                  ),
                ],
              ),

              SizedBox(height: Constant.CONTAINER_SIZE_12),

              Expanded(
                child: ListView(
                  children: [
                    _containerItem(widget.orderData.productName??"",
                       widget.orderData.approvedQty.toString()),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _timelineCard() {
    return Container(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: _buildTimelineItems(),
      ),
    );
  }

  List<Widget> _buildTimelineItems() {
    List<Widget> items = [];

    items.add(_timelineItem(
      icon: Icons.check_circle,
      color: Colors.lightGreenAccent,
      title: "Ordered on: ${widget.orderData.orderDate!.split(" ").take(1).join()}",
      time: widget.orderData.orderDate!.split(" ").sublist(1).join(),
      showLine: widget.status != "PENDING",
    ));

    if (widget.status == "CONFIRMED" ||
        widget.status == "DELIVERED") {
      items.add(_timelineItem(
        icon: Icons.check_circle,
        color: Colors.lightGreenAccent,
        title: "Confirmed on: ${widget.orderData.decisionAt!.split(" ").take(1).join()}",
        time: widget.orderData.decisionAt!.split(" ").sublist(1).join(),
        showLine: widget.status == "DELIVERED",
      ));
    }

    if (widget.status == "DELIVERED") {
      items.add(_timelineItem(
        icon: Icons.check_circle,
        color: Colors.lightGreenAccent,
        title: "Delivered on: ${widget.orderData.decisionAt!.split(" ").take(1).join()}",
        time: widget.orderData.decisionAt!.split(" ").sublist(1).join(),
        showLine: false,
      ));
    }

    if (widget.status == "REJECTED") {
      items.add(_timelineItem(
        icon: Icons.cancel,
        color: Colors.redAccent,
        title: "Rejected on: ${widget.orderData.decisionAt!.split(" ").take(1).join()}",
        time: widget.orderData.decisionAt!.split(" ").sublist(1).join(),
        showLine: false,
      ));
    }

    return items;
  }

  Widget _timelineItem({
    required IconData icon,
    required Color color,
    required String title,
    required String time,
    required bool showLine,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(icon, color: color, size: 20),
            if (showLine)
              Container(
                width: 1,
                height: 28,
                color: Colors.lightGreenAccent,
              ),
          ],
        ),
        SizedBox(width: Constant.SIZE_10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white)),
            Text("Time: $time",
                style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _containerItem(
      String title,
      // String code,
      // String volume,
      String qty,
      ) {
    return Container(
      margin: EdgeInsets.only(bottom: Constant.SIZE_10),
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_14),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.inventory_2, color: Colors.white),
          ),
          SizedBox(width: Constant.SIZE_10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(color: Colors.white, fontSize: 15)),
              ],
            ),
          ),

          Text(
            qty,
            style: const TextStyle(
              color: Colors.amber,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
