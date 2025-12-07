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
      // Use LayoutBuilder at top-level to compute responsive values for the whole screen.
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // baseWidth is an assumed design width you used when creating UI (approx).
            // This is used only to create a mild scale factor; it won't change visuals.
            final double baseWidth = 375.0;
            final double scale = constraints.maxWidth / baseWidth;

            // Heights for top section and grid are derived from available height.
            final double totalHeight = constraints.maxHeight;
            // Ensure we reserve some space for bottom sheet trigger and history
            final double gridAreaHeight = (totalHeight * 0.26).clamp(140.0, 400.0);
            final double topCardImageHeight = (90.0 * scale).clamp(80.0, 220.0);

            // dynamic childAspectRatio for cards so they remain visually similar across widths
            final double cardWidth = (constraints.maxWidth - 32 /*padding*/ - 8) / 2;
            // approximate desired card height (so top card look stays similar)
            final double desiredCardHeight = 90.0 * scale; // increased from 70.0 to 90.0
            final double childAspectRatio = cardWidth / desiredCardHeight;

            return SingleChildScrollView(
              padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16 * scale),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title centered: use FittedBox so it shrinks on small screens and grows on large.
                  Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        restaurant.name,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontSize: (Constant.LABEL_TEXT_SIZE_16 * (1.0 * scale)).clamp(12.0, 22.0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Constant.CONTAINER_SIZE_12 * scale),

                  // Grid of cards: shrinkWrap true with a constrained height to avoid overflow
                  SizedBox(
                    height: gridAreaHeight,
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: containerCards.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0 * scale,
                        mainAxisSpacing: 8.0 * scale,
                        childAspectRatio: childAspectRatio,
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
                          child: _buildContainersInfo(context, containerCards[index], scale),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: Constant.CONTAINER_SIZE_16 * scale),

                  Center(
                    child: GestureDetector(
                      onTap: () {
                        showRestaurantDetailsSheet(context, restaurant, themeData!);
                      },
                      child: Text(
                        Strings.VIEW_RESTURANT_DETAILS,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: (Constant.LABEL_TEXT_SIZE_16 * scale).clamp(12.0, 18.0),
                          color: themeData!.primaryColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: Constant.CONTAINER_SIZE_24 * scale),

                  // Restaurant history: use Flexible elements inside rows so long texts don't overflow.
                  _buildRestaurantHistory(context, scale),

                  SizedBox(height: Constant.CONTAINER_SIZE_24 * scale),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContainersInfo(BuildContext context, Map<String, dynamic> item, double scale) {
    return Container(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12 * scale),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(Constant.SIZE_08 * scale),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                item['title'],
                style: TextStyle(
                  fontSize: (Constant.CONTAINER_SIZE_14 * scale).clamp(10.0, 14.0),
                  color: Colors.grey.shade700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(height: Constant.SIZE_04 * scale),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              item['value'].toString(),
              style: TextStyle(
                fontSize: (Constant.CONTAINER_SIZE_18 * scale).clamp(14.0, 24.0),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantHistory(BuildContext context, double scale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                Strings.RESTURANT_HISTORY,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: (Constant.LABEL_TEXT_SIZE_18 * scale).clamp(14.0, 20.0),
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
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
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: (Constant.LABEL_TEXT_SIZE_14 * scale).clamp(12.0, 16.0),
                  color: Color(0xFF8daba0), fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: Constant.CONTAINER_SIZE_16 * scale),

        _buildHistoryRow(
          context,
          scale: scale,
          title: "Requested on",
          date: "20/11/2025",
          count: "50",
          status: "Pending",
          statusColor: Color(0xFFfadb7f),
        ),

        Divider(
          color: Colors.grey.shade300,
          height: Constant.CONTAINER_SIZE_24 * scale,
        ),

        _buildHistoryRow(
          context,
          scale: scale,
          title: "Approved on",
          date: "01/10/2025",
          count: "100",
          status: "Approved",
          statusColor: Color(0xFF75c487),
        ),

        Divider(
          color: Colors.grey.shade300,
          height: Constant.CONTAINER_SIZE_24 * scale,
        ),

        _buildHistoryRow(
          context,
          scale: scale,
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
        required double scale,
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
          // Left column: title + date. Use Expanded so it takes available space and text wraps.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: (Constant.LABEL_TEXT_SIZE_14 * scale).clamp(12.0, 14.0),
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: Constant.SIZE_04 * scale),
                Text(
                  date,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: (Constant.LABEL_TEXT_SIZE_14 * scale).clamp(12.0, 14.0),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Right column: count + status. Constrain width so it doesn't push overflow.
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: 48 * scale, maxWidth: 120 * scale),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    count,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: (Constant.LABEL_TEXT_SIZE_16 * scale).clamp(12.0, 18.0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: Constant.SIZE_04 * scale),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    status,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: (Constant.CONTAINER_SIZE_12 * scale).clamp(10.0, 12.0),
                      color: statusColor, fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: Constant.SIZE_08 * scale),
          Icon(
            Icons.chevron_right,
            size: (Constant.CONTAINER_SIZE_20 * scale).clamp(16.0, 28.0),
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
            // Use LayoutBuilder inside sheet to make image and spacing responsive.
            return LayoutBuilder(builder: (context, sheetConstraints) {
              final double sheetHeight = sheetConstraints.maxHeight;
              final double imgHeight = (sheetHeight * 0.28).clamp(120.0, 260.0);

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
                              height: imgHeight,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),

                          SizedBox(height: Constant.CONTAINER_SIZE_16),

                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              restaurant.name,
                              style: TextStyle(
                                fontSize: Constant.CONTAINER_SIZE_20,
                                fontWeight: FontWeight.w700,
                              ),
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
                              Expanded(
                                child: Text(
                                  "9875643212",
                                  style: TextStyle(
                                    fontSize: Constant.CONTAINER_SIZE_14,
                                    color: Colors.grey.shade700,
                                  ),
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
            });
          },
        );
      },
    );
  }
}
