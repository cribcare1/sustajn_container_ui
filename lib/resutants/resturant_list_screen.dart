import 'package:container_tracking/common_widgets/custom_back_button.dart';
import 'package:flutter/material.dart';

import '../../../constants/number_constants.dart';
import '../common_widgets/custom_app_bar.dart';
import 'model.dart';
class RestaurantListScreen extends StatefulWidget {
  const RestaurantListScreen({super.key});

  @override
  State<RestaurantListScreen> createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Restaurant> restaurants = [
    Restaurant(
      name: "Jamavar",
      totalContainers: 150,
      borrowedContainers: 45,
    ),
    Restaurant(
      name: "Shiro",
      totalContainers: 200,
      borrowedContainers: 180,
    ),
    Restaurant(
      name: "Urban Kitchen",
      totalContainers: 80,
      borrowedContainers: 75,
    ),
    Restaurant(
      name: "Sunset Diner",
      totalContainers: 120,
      borrowedContainers: 30,
    ),
  ];

  List<Restaurant> filteredRestaurants = [];

  @override
  void initState() {
    filteredRestaurants = restaurants;
    super.initState();
  }

  void _filterRestaurants(String query) {
    setState(() {
      filteredRestaurants = restaurants.where((restaurant) {
        return restaurant.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  // resturant card
  Widget _buildRestaurantCard(Restaurant restaurant) {
    return Card(
      margin: EdgeInsets.only(bottom: Constant.CONTAINER_SIZE_16),
      elevation: Constant.SIZE_01,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RestaurantDetailScreen(restaurant: restaurant),
            ),
          );
        },
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
        child: Padding(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
          child: Row(
            children: [
              // Restaurant Icon
              Container(
                width: Constant.CONTAINER_SIZE_50,
                height: Constant.CONTAINER_SIZE_50,
                decoration: BoxDecoration(
                  color: Color(0xffb3dbff),
                  borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                ),
                child: Icon(
                  Icons.restaurant,
                  color: Colors.blue[700],
                  size: Constant.CONTAINER_SIZE_24,
                ),
              ),
              SizedBox(width: Constant.CONTAINER_SIZE_16),

              // Restaurant Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      style: TextStyle(
                        fontSize: Constant.LABEL_TEXT_SIZE_18,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: Constant.MAX_LINE_1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: Constant.SIZE_08),
                    Row(
                      children: [
                        _buildInfoChip(
                          icon: Icons.inventory_2,
                          value: '${restaurant.totalContainers}',
                          label: 'Total',
                          color: Constant.blueshade100,
                        ),
                        SizedBox(width: Constant.SIZE_08),
                        _buildInfoChip(
                          icon: Icons.shopping_basket,
                          value: '${restaurant.borrowedContainers}',
                          label: 'Borrowed',
                          color: Constant.tealshade100,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildInfoChip({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Constant.SIZE_08,
        vertical: Constant.SIZE_04,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(Constant.SIZE_08),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: Constant.CONTAINER_SIZE_12),
          SizedBox(width: Constant.SIZE_04),
          Text(
            '$value $label',
            style: TextStyle(
              fontSize: Constant.CONTAINER_SIZE_12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          leading: const SizedBox(),
          title: "Restaurants").getAppBar(context),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
            child: Container(
              height: Constant.TEXT_FIELD_HEIGHT,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(Constant.SIZE_005),
                    blurRadius: Constant.SIZE_02,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterRestaurants,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: 'Search restaurants',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: Constant.CONTAINER_SIZE_16,
                  ),
                ),
              ),
            ),
          ),

          // Restaurant List
          Expanded(
            child: filteredRestaurants.isEmpty
                ? Center(
              child: Text(
                'No restaurants found',
                style: TextStyle(
                  fontSize: Constant.LABEL_TEXT_SIZE_16,
                  color: Colors.grey,
                ),
              ),
            )
                : ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: Constant.CONTAINER_SIZE_16,
              ),
              itemCount: filteredRestaurants.length,
              itemBuilder: (context, index) {
                final restaurant = filteredRestaurants[index];
                return _buildRestaurantCard(restaurant);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  const _RestaurantCard({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: Constant.CONTAINER_SIZE_16),
      elevation: Constant.SIZE_01,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RestaurantDetailScreen(restaurant: restaurant),
            ),
          );
        },
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
        child: Padding(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
          child: Row(
            children: [
              // Restaurant Icon
              Container(
                width: Constant.CONTAINER_SIZE_50,
                height: Constant.CONTAINER_SIZE_50,
                decoration: BoxDecoration(
                  color:Color(0xffb3dbff),
                  borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                ),
                child: Icon(
                  Icons.restaurant,
                  // color: Color(0xffb3dbff),
                  color: Colors.blue[700],
                  size: Constant.CONTAINER_SIZE_24,
                ),
              ),
              SizedBox(width: Constant.CONTAINER_SIZE_16),

              // Restaurant Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      style: TextStyle(
                        fontSize: Constant.LABEL_TEXT_SIZE_18,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: Constant.MAX_LINE_1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: Constant.SIZE_08),
                    Row(
                      children: [
                        _InfoChip(
                          icon: Icons.inventory_2,
                          value: '${restaurant.totalContainers}',
                          label: 'Total',
                          color: Constant.blueshade100,
                        ),
                        SizedBox(width: Constant.SIZE_08),
                        _InfoChip(
                          icon: Icons.shopping_basket,
                          value: '${restaurant.borrowedContainers}',
                          label: 'Borrowed',
                          color: Constant.tealshade100,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Constant.SIZE_08,
        vertical: Constant.SIZE_04,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(Constant.SIZE_08),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: Constant.CONTAINER_SIZE_12),
          SizedBox(width: Constant.SIZE_04),
          Text(
            '$value $label',
            style: TextStyle(
              fontSize: Constant.CONTAINER_SIZE_12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}


class RestaurantDetailScreen extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantDetailScreen({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final availableContainers = restaurant.totalContainers - restaurant.borrowedContainers;
    final usagePercentage = (restaurant.borrowedContainers / restaurant.totalContainers) * 100;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar:CustomAppBar(
          leading: const CustomBackButton(),
          title: restaurant.name).getAppBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
        child: Column(
          children: [
            // Header Card with Restaurant Info
            // Card(
            //   elevation: Constant.SIZE_01,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
            //   ),
            //   child: Padding(
            //     padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
            //     child: Column(
            //       children: [
            //         Container(
            //           width: Constant.CONTAINER_SIZE_80,
            //           height: Constant.CONTAINER_SIZE_80,
            //           decoration: BoxDecoration(
            //             color: Constant.blueshade100,
            //             shape: BoxShape.circle,
            //           ),
            //           child: Icon(
            //             Icons.restaurant,
            //             color: Colors.blue[700],
            //             size: Constant.CONTAINER_SIZE_40,
            //           ),
            //         ),
            //         SizedBox(height: Constant.CONTAINER_SIZE_16),
            //         Text(
            //           restaurant.name,
            //           style: TextStyle(
            //             fontSize: Constant.LABEL_TEXT_SIZE_24,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //         SizedBox(height: Constant.SIZE_08),
            //         Text(
            //           'Container Usage Overview',
            //           style: TextStyle(
            //             fontSize: Constant.LABEL_TEXT_SIZE_16,
            //             color: Colors.grey,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            SizedBox(height: Constant.CONTAINER_SIZE_16),

            // Usage
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
                    _UsageProgressBar(
                      percentage: usagePercentage,
                      borrowed: restaurant.borrowedContainers,
                      total: restaurant.totalContainers,
                    ),
                    SizedBox(height: Constant.CONTAINER_SIZE_20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatCircle(
                          value: restaurant.totalContainers.toString(),
                          label: 'Total',
                          color: Constant.blueshade100,
                          textColor: Colors.blue,
                        ),
                        _StatCircle(
                          value: restaurant.borrowedContainers.toString(),
                          label: 'Borrowed',
                          color: Constant.orangeshade100,
                          textColor: Colors.orange,
                        ),
                        _StatCircle(
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

            // Detailed Breakdown
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
                    _DetailItem(
                      icon: Icons.inventory_2,
                      title: 'Total Containers',
                      value: '${restaurant.totalContainers}',
                      subtitle: 'Maximum container capacity',
                      color: Constant.blueshade100,
                    ),
                    SizedBox(height: Constant.CONTAINER_SIZE_16),
                    _DetailItem(
                      icon: Icons.shopping_basket,
                      title: 'Borrowed Containers',
                      value: '${restaurant.borrowedContainers}',
                      subtitle: 'Currently with customers',
                      color: Constant.orangeshade100,
                    ),
                    SizedBox(height: Constant.CONTAINER_SIZE_16),
                    _DetailItem(
                      icon: Icons.warehouse,
                      title: 'Available Containers',
                      value: availableContainers.toString(),
                      subtitle: 'Ready for use',
                      color: Constant.greenshade100,
                    ),
                    SizedBox(height: Constant.CONTAINER_SIZE_16),
                    _DetailItem(
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

class _UsageProgressBar extends StatelessWidget {
  final double percentage;
  final int borrowed;
  final int total;

  const _UsageProgressBar({
    required this.percentage,
    required this.borrowed,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
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
}

class _StatCircle extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final Color textColor;

  const _StatCircle({
    required this.value,
    required this.label,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
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
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  const _DetailItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
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
}
