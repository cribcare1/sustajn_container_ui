import 'package:container_tracking/resutants/screens/resturant_transaction_history.dart';
import 'package:container_tracking/resutants/screens/transaction_details_bottomsheet.dart';
import 'package:flutter/material.dart';

import '../../common_widgets/custom_app_bar.dart';
import '../../common_widgets/custom_back_button.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../utils/theme_utils.dart';
import '../models/model.dart';
import 'container_count_details.dart';

class RestaurantDetailsScreen extends StatelessWidget {
  final Restaurant restaurant;

  RestaurantDetailsScreen({super.key, required this.restaurant});

  final List<Map<String, dynamic>> containerCards = [
    {'title': "Total Containers Issued", 'value': 2343},
    {'title': "Total available", 'value': 1354},
    {'title': "Total Issued to the Customers", 'value': 1543},
    {'title': "Total Returned from Customers", 'value': 234},
  ];

  @override
  Widget build(BuildContext context) {
    final themeData = CustomTheme.getTheme(true);
    return Scaffold(
      appBar: CustomAppBar(
        title: Strings.RESTURANT_DETAILS_TITLE,
        leading: CustomBackButton(),
      ).getAppBar(context),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  restaurant.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: Constant.LABEL_TEXT_SIZE_16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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

              Center(
                child: GestureDetector(
                  onTap: () {
                    showRestaurantDetailsSheet(context, restaurant, themeData!);
                  },
                  child: Text(
                    Strings.VIEW_RESTURANT_DETAILS,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: Constant.LABEL_TEXT_SIZE_16,
                      color: Color(0xFF8daba0),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),

              SizedBox(height: Constant.CONTAINER_SIZE_24),

              _buildRestaurantHistory(context),
              SizedBox(height: Constant.CONTAINER_SIZE_24),
            ],
          ),
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

  void showRestaurantDetailsSheet(
    BuildContext context,
    Restaurant restaurant,
    ThemeData themeData,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.65,
          maxChildSize: 0.85,
          minChildSize: 0.50,
          builder: (_, controller) {
            return Container(
              padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(Constant.CONTAINER_SIZE_24),
                ),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    controller: controller,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            Constant.CONTAINER_SIZE_12,
                          ),
                          child: Image.asset(
                            restaurant.imageUrl,
                            height: Constant.CONTAINER_SIZE_180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),

                        SizedBox(height: Constant.CONTAINER_SIZE_16),

                        Text(
                          restaurant.name,
                          style: TextStyle(
                            fontSize: Constant.CONTAINER_SIZE_20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        SizedBox(height: Constant.SIZE_10),

                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: Constant.CONTAINER_SIZE_20,
                              color: Colors.grey.shade700,
                            ),
                            SizedBox(width: Constant.SIZE_06),
                            Expanded(
                              child: Text(
                                restaurant.address,
                                style: TextStyle(
                                  fontSize: Constant.CONTAINER_SIZE_14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: Constant.SIZE_08),

                        Row(
                          children: [
                            Icon(
                              Icons.phone,
                              size: Constant.CONTAINER_SIZE_20,
                              color: Colors.grey.shade700,
                            ),
                            SizedBox(width: Constant.SIZE_06),
                            Text(
                              "9875643212",
                              style: TextStyle(
                                fontSize: Constant.CONTAINER_SIZE_14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: Constant.CONTAINER_SIZE_20),

                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: Constant.CONTAINER_SIZE_14,
                              ),
                              side: BorderSide(
                                color: Color(0xFF3f715e),
                                width: 1.4,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  Constant.CONTAINER_SIZE_12,
                                ),
                              ),
                            ),
                            onPressed: () {},
                            child: Text(
                              "📞   ${Strings.CALL}",
                              style: TextStyle(
                                fontSize: Constant.CONTAINER_SIZE_16,

                                color: Color(0xFF3f715e),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: Constant.CONTAINER_SIZE_14),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF3f715e),
                              padding: EdgeInsets.symmetric(
                                vertical: Constant.CONTAINER_SIZE_14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  Constant.CONTAINER_SIZE_12,
                                ),
                              ),
                            ),
                            onPressed: () {},
                            child: Text(
                              Strings.DIRECTION,
                              style: TextStyle(
                                fontSize: Constant.CONTAINER_SIZE_16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: Constant.CONTAINER_SIZE_20),
                      ],
                    ),
                  ),

                  Positioned(
                    right: 0,
                    top: 0,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(Constant.SIZE_04),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          size: Constant.CONTAINER_SIZE_26,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
