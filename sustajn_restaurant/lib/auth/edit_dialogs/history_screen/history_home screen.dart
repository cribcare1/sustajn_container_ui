import 'package:flutter/material.dart';
import 'package:sustajn_restaurant/auth/edit_dialogs/history_screen/sold_screen.dart';
import 'package:sustajn_restaurant/common_widgets/custom_back_button.dart';
import 'package:sustajn_restaurant/product_screen/lease_screen/lease_screen.dart';
import 'package:sustajn_restaurant/product_screen/receive_screen/receive_screen.dart';

import '../../../constants/number_constants.dart';
import '../../../constants/string_utils.dart';
import '../../../order_screen/order_screen/order_screen.dart';
import '../../../utils/theme_utils.dart';
import '../../../utils/utility.dart';
import 'damaged_screen.dart';

class HistoryHomeScreen extends StatefulWidget {
  const HistoryHomeScreen({super.key});

  @override
  State<HistoryHomeScreen> createState() => _HistoryHomeScreenState();
}

class _HistoryHomeScreenState extends State<HistoryHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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
          Strings.HISTORY,
          style: theme!.textTheme.titleMedium!.copyWith(color: Colors.white),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
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
                  Icon(Icons.call_made_outlined, size: Constant.CONTAINER_SIZE_18),
                  SizedBox(width: Constant.SIZE_04),
                  Text(Strings.LEASED),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.call_received_outlined, size: Constant.CONTAINER_SIZE_18),
                  SizedBox(width: Constant.SIZE_04),
                  Text(Strings.RECEIVED),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: Constant.CONTAINER_SIZE_18),
                  SizedBox(width: Constant.SIZE_04),
                  Text(Strings.ORDERED),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageIcon(
                    AssetImage('assets/images/img.png'),
                    size: Constant.CONTAINER_SIZE_18,
                  ),
                  SizedBox(width: Constant.SIZE_04),
                  Text(Strings.DAMAGED),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.reset_tv_outlined, size: Constant.CONTAINER_SIZE_18),
                  SizedBox(width: Constant.SIZE_04),
                  Text(Strings.SOLD),
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
                LeaseScreen(),
                ReceiveScreen(),
                OrderHistoryScreen(),
                DamagedScreen(),
                SoldScreen()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
