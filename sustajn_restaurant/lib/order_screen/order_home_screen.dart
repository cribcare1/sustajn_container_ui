import 'package:flutter/material.dart';
import 'package:sustajn_restaurant/common_widgets/custom_back_button.dart';
import 'package:sustajn_restaurant/order_screen/return_container_screen/return_container_screen.dart';

import '../constants/number_constants.dart';
import '../utils/theme_utils.dart';
import 'container_screen/add_container_screen.dart';
import 'order_screen/order_screen.dart';


class OrderHomeScreen extends StatefulWidget {
  const OrderHomeScreen({super.key});

  @override
  State<OrderHomeScreen> createState() => _OrderHomeScreenState();
}

class _OrderHomeScreenState extends State<OrderHomeScreen>
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
      backgroundColor: const Color(0xFF0E3B2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E3B2E),
        elevation: 0,
        centerTitle: true,
        leading: CustomBackButton(),
        title: Text(
          'Order',
          style: theme!.textTheme.titleMedium!.copyWith(color: Colors.white),
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
                  ImageIcon(
                    AssetImage('assets/images/img.png'),
                    size: Constant.CONTAINER_SIZE_16,
                  ),
                  SizedBox(width: Constant.SIZE_06),
                  Text('Containers'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.reset_tv_outlined, size: Constant.CONTAINER_SIZE_18),
                  SizedBox(width: Constant.SIZE_06),
                  Text('Return'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: Constant.CONTAINER_SIZE_18),
                  SizedBox(width: Constant.CONTAINER_SIZE_06),
                  Text('History'),
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
              children: [
                AddContainerScreen(),
                ReturnContainerScreen(),
                OrdersScreen()
              ],
            ),
          ),
        ],
      ),
    );
  }


}
