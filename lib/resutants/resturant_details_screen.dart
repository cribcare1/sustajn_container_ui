import 'package:flutter/material.dart';

import '../../../constants/number_constants.dart';
import 'model.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantDetailScreen({super.key, required this.restaurant});


  Widget _buildUsageProgressBar(double percentage, int borrowed, int total) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Container Usage',
              style: TextStyle(
                fontSize: Constant.LABEL_TEXT_SIZE_14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: Constant.LABEL_TEXT_SIZE_14,
                fontWeight: FontWeight.w600,
                color: _getPercentageColor(percentage),
              ),
            ),
          ],
        ),
        SizedBox(height: Constant.SIZE_08),
        LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(_getPercentageColor(percentage)),
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_10),
          minHeight: Constant.CONTAINER_SIZE_12,
        ),
        SizedBox(height: Constant.SIZE_08),
        Text(
          '$borrowed out of $total containers are currently borrowed',
          style: TextStyle(
            fontSize: Constant.CONTAINER_SIZE_12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Color _getPercentageColor(double percentage) {
    if (percentage < 50) return Colors.green;
    if (percentage < 80) return Colors.orange;
    return Colors.red;
  }


  Widget _buildStatCircle({
    required String value,
    required String label,
    required Color color,
    required Color textColor,
  }) {
    return Column(
      children: [
        Container(
          width: Constant.CONTAINER_SIZE_70,
          height: Constant.CONTAINER_SIZE_70,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: Constant.LABEL_TEXT_SIZE_18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
        SizedBox(height: Constant.SIZE_08),
        Text(
          label,
          style: TextStyle(
            fontSize: Constant.CONTAINER_SIZE_12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // detail item
  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: Constant.CONTAINER_SIZE_20),
        ),
        SizedBox(width: Constant.CONTAINER_SIZE_16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: Constant.LABEL_TEXT_SIZE_14,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: Constant.SIZE_04),
              Text(
                value,
                style: TextStyle(
                  fontSize: Constant.LABEL_TEXT_SIZE_18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: Constant.SIZE_02),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: Constant.CONTAINER_SIZE_12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final availableContainers = restaurant.totalContainers - restaurant.borrowedContainers;
    final usagePercentage = (restaurant.borrowedContainers / restaurant.totalContainers) * 100;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          restaurant.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xff6eac9e),
        elevation: Constant.SIZE_00,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
        child: Column(
          children: [
            SizedBox(height: Constant.CONTAINER_SIZE_16),

            // Usage Statistics Card
            Card(
              elevation: Constant.SIZE_01,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
              ),
              child: Padding(
                padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Usage Statistics',
                      style: TextStyle(
                        fontSize: Constant.LABEL_TEXT_SIZE_18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: Constant.CONTAINER_SIZE_16),
                    _buildUsageProgressBar(
                      usagePercentage,
                      restaurant.borrowedContainers,
                      restaurant.totalContainers,
                    ),
                    SizedBox(height: Constant.CONTAINER_SIZE_20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCircle(
                          value: restaurant.totalContainers.toString(),
                          label: 'Total',
                          color: Constant.blueshade100,
                          textColor: Colors.blue,
                        ),
                        _buildStatCircle(
                          value: restaurant.borrowedContainers.toString(),
                          label: 'Borrowed',
                          color: Constant.orangeshade100,
                          textColor: Colors.orange,
                        ),
                        _buildStatCircle(
                          value: availableContainers.toString(),
                          label: 'Available',
                          color: Constant.greenshade100,
                          textColor: Colors.green,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_16),

            // Detailed Breakdown Card
            Card(
              elevation: Constant.SIZE_01,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
              ),
              child: Padding(
                padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detailed Breakdown',
                      style: TextStyle(
                        fontSize: Constant.LABEL_TEXT_SIZE_18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: Constant.CONTAINER_SIZE_16),
                    _buildDetailItem(
                      icon: Icons.inventory_2,
                      title: 'Total Containers',
                      value: '${restaurant.totalContainers}',
                      subtitle: 'Maximum container capacity',
                      color: Constant.blueshade100,
                    ),
                    SizedBox(height: Constant.CONTAINER_SIZE_16),
                    _buildDetailItem(
                      icon: Icons.shopping_basket,
                      title: 'Borrowed Containers',
                      value: '${restaurant.borrowedContainers}',
                      subtitle: 'Currently with customers',
                      color: Constant.orangeshade100,
                    ),
                    SizedBox(height: Constant.CONTAINER_SIZE_16),
                    _buildDetailItem(
                      icon: Icons.warehouse,
                      title: 'Available Containers',
                      value: availableContainers.toString(),
                      subtitle: 'Ready for use',
                      color: Constant.greenshade100,
                    ),
                    SizedBox(height: Constant.CONTAINER_SIZE_16),
                    _buildDetailItem(
                      icon: Icons.percent,
                      title: 'Usage Rate',
                      value: '${usagePercentage.toStringAsFixed(1)}%',
                      subtitle: 'Borrowed vs Total',
                      color: Constant.indigoShade100,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}