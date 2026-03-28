import 'package:container_tracking/Screen/Partner/product/receive_screen.dart';
import 'package:flutter/material.dart';

import '../../../common_widgets/custom_back_button.dart';
import '../../../constants/number_constants.dart';
import '../../../constants/string_utils.dart';
import '../../../utils/theme_utils.dart';
import 'inventory_screen.dart';
import 'lease_screen.dart';


class ProductsHomeScreen extends StatefulWidget {
  final int? restaurantId;
  const ProductsHomeScreen({super.key, required this.restaurantId});

  @override
  State<ProductsHomeScreen> createState() => _ProductsHomeScreenState();
}

class _ProductsHomeScreenState extends State<ProductsHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = CustomTheme.getTheme(true);
    return Scaffold(
      backgroundColor: theme!.primaryColor,
      appBar: AppBar(
        backgroundColor:theme.primaryColor,
        elevation: 0,
        centerTitle: false,
        leading: CustomBackButton(),
        title: Text(
          Strings.PRODUCTS,
          style: theme  .textTheme.titleMedium!.copyWith(color: Colors.white),
        ),
        bottom: TabBar(
          controller: _tabController,
          dividerColor: Constant.grey.withOpacity(0.3),
          indicatorColor: Colors.amber,
          indicatorWeight: 3,
          labelColor: Colors.amber,
          unselectedLabelColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(Strings.BOWL_IMG, height: Constant.CONTAINER_SIZE_16, width: Constant.CONTAINER_SIZE_16),
                  // ImageIcon(

                    // AssetImage(Strings.BOWL_IMG),
                    // size: Constant.CONTAINER_SIZE_16,
                  // ),
                  SizedBox(width: Constant.SIZE_06),
                  Text(Strings.INVENTORY),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.call_made_outlined,
                    size: Constant.CONTAINER_SIZE_18,
                  ),
                  SizedBox(width: Constant.SIZE_06),
                  Text(Strings.LEASE),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.call_received_outlined,
                    size: Constant.CONTAINER_SIZE_18,
                  ),
                  SizedBox(width: Constant.SIZE_06),
                  Text(Strings.RECEIVE),
                ],
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [InventoryScreen(restaurantId: widget.restaurantId!), LeaseScreen(restaurantId: widget.restaurantId!), ReceiveScreen(restaurantId: widget.restaurantId!)],
            ),
          ),
        ],
      ),
    );
  }
}
