import 'package:container_tracking/auth/screens/resutants/resturant_details_screen.dart';
import 'package:flutter/material.dart';

import '../../../constants/number_constants.dart';
import 'model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const RestaurantListScreen(),
    );
  }
}

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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Restaurants'),
        backgroundColor: Color(0xff6eac9e),
        elevation: Constant.SIZE_00,
        foregroundColor: Colors.black,
      ),
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

