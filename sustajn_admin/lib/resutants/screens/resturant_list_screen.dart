import 'package:container_tracking/resutants/screens/resturant_details_screen.dart';
import 'package:flutter/material.dart';

import '../../common_widgets/custom_app_bar.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../models/model.dart';

class RestaurantListScreen extends StatefulWidget {
  const RestaurantListScreen({super.key});

  @override
  State<RestaurantListScreen> createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  final List<Restaurant> restaurants = [
    Restaurant(
      name: "FlavourFusion Bistro",
      containers: 1354,
      address: "Al Marsa Street 57, Dubai Marina, PO",
      imageUrl: "assets/images/resturant.jpeg",
    ),
    Restaurant(
      name: "Marbel Mist Manor",
      containers: 1233,
      address: "Al Marsa Street 57, Dubai Marina, PO",
      imageUrl: "assets/images/resturant.jpeg",
    ),
    Restaurant(
      name: "The Crystal Fork",
      containers: 4322,
      address: "Al Marsa Street 57, Dubai Marina, PO",
      imageUrl: "assets/images/resturant.jpeg",
    ),
    Restaurant(
      name: "Velvet Vineyar",
      containers: 323,
      address: "Al Marsa Street 57, Dubai Marina, PO",
      imageUrl: "assets/images/resturant.jpeg",
    ),
    Restaurant(
      name: "The Silver Flame",
      containers: 432,
      address: "Al Marsa Street 57, Dubai Marina, PO",
      imageUrl: "assets/images/resturant.jpeg",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Strings.RESTURANT_TITLE,
        leading: SizedBox.shrink(),
        action: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
        ]
      ).getAppBar(context),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container(
              //   height: Constant.TEXT_FIELD_HEIGHT,
              //   decoration: BoxDecoration(
              //     color: Colors.grey.shade100,
              //     borderRadius: BorderRadius.circular(
              //       Constant.CONTAINER_SIZE_10,
              //     ),
              //   ),
              //   child: TextField(
              //     decoration: InputDecoration(
              //       prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
              //       hintText: Strings.SEARCH_RESTURANTS,
              //       border: InputBorder.none,
              //       contentPadding: EdgeInsets.symmetric(
              //         horizontal: Constant.CONTAINER_SIZE_16,
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(height: Constant.CONTAINER_SIZE_16),
              // todo this may need in future
              // Total Count
              // Text(
              //   "Total - ${restaurants.length}",
              //   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              //     fontSize: Constant.LABEL_TEXT_SIZE_16,
              //     color: Colors.grey.shade700,
              //     fontWeight: FontWeight.bold
              //   ),
              // ),
              // SizedBox(height: Constant.CONTAINER_SIZE_16),
              Expanded(
                child: ListView.separated(
                  itemCount: restaurants.length,
                  separatorBuilder: (context, index) =>SizedBox(height: Constant.CONTAINER_SIZE_10,),
                  itemBuilder: (context, index) {
                    return _buildRestaurantCard(restaurants[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRestaurantCard(Restaurant restaurant) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Constant.CONTAINER_SIZE_12,
        horizontal: Constant.SIZE_008,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  RestaurantDetailsScreen(restaurant: restaurant),
            ),
          );
        },
        leading: Container(
          width: Constant.CONTAINER_SIZE_50,
          height: Constant.CONTAINER_SIZE_50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Constant.SIZE_08),
            image: DecorationImage(
              image: AssetImage(restaurant.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          restaurant.name,maxLines: 1,overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.ramen_dining,
                  size: Constant.CONTAINER_SIZE_12,
                  color: Colors.grey.shade600,
                ),
                SizedBox(width: Constant.SIZE_04),
                Text(
                  restaurant.containers.toString(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: Constant.LABEL_TEXT_SIZE_14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            SizedBox(height: Constant.SIZE_02),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: Constant.CONTAINER_SIZE_12,
                  color: Colors.grey.shade600,
                ),
                SizedBox(width: Constant.SIZE_04),
                Expanded(
                  child: Text(
                    restaurant.address,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: Constant.CONTAINER_SIZE_12,
                      color: Colors.grey.shade500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
