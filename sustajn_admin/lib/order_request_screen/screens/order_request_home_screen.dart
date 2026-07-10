import 'package:container_tracking/order_request_screen/screens/pending_screen.dart';
import 'package:container_tracking/order_request_screen/screens/rejected_screen.dart';
import 'package:flutter/material.dart';
import '../../common_widgets/custom_back_button.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../utils/theme_utils.dart';
import 'confirmed_screen.dart';
import 'delivered_screen.dart';

class OrderRequestScreen extends StatefulWidget {
  const OrderRequestScreen({super.key});

  @override
  State<OrderRequestScreen> createState() => _OrderRequestScreenState();
}

class _OrderRequestScreenState extends State<OrderRequestScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
          Strings.ORDER_REQUEST,
          style: theme  .textTheme.titleMedium!.copyWith(color: Colors.white),
        ),
        bottom: TabBar(
          controller: _tabController,
          dividerColor: Constant.grey.withOpacity(0.3),
          indicatorColor: Colors.amber,
          padding: EdgeInsets.zero, // 👈 removes outer padding
          tabAlignment: TabAlignment.start,
          indicatorWeight: Constant.SIZE_04,
          labelColor: Colors.amber,
          isScrollable: true,
          unselectedLabelColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageIcon(
                    const AssetImage('assets/images/pending.png'),
                    size: Constant.CONTAINER_SIZE_16,
                  ),
                  SizedBox(width: Constant.SIZE_06),
                  Text(Strings.PENDING,overflow: TextOverflow.ellipsis,),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageIcon(
                    const AssetImage('assets/images/Confirmed.png'),
                    size: Constant.CONTAINER_SIZE_18,
                  ),
                  SizedBox(width: Constant.SIZE_06),
                  const Text(Strings.CONFIRMED),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageIcon(
                    const AssetImage('assets/images/Delivered.png'),
                    size: Constant.CONTAINER_SIZE_18,
                  ),
                  SizedBox(width: Constant.SIZE_06),
                  const Text(Strings.DELIVERED),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageIcon(
                    const AssetImage('assets/images/rejected.png'),
                    size: Constant.CONTAINER_SIZE_18,
                  ),
                  SizedBox(width: Constant.SIZE_06),
                  const Text(Strings.REJECTED),
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
                PendingScreen(),
                ConfirmedScreen(),
                DeliveredScreen(),
                RejectedScreen()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
