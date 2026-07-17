import 'package:flutter/material.dart';
import '../common_widgets/custom_back_button.dart';
import '../constants/number_constants.dart';
import '../constants/string_utils.dart';
import '../utils/theme_utils.dart';
import 'incirculation_screen.dart';
import 'inventory_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen>
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
                  ImageIcon(
                    const AssetImage('assets/icons/inventory.png'),
                    size: Constant.CONTAINER_SIZE_16,
                  ),
                  SizedBox(width: Constant.SIZE_06),
                  const Text(Strings.INVENTORY),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageIcon(
                    const AssetImage('assets/icons/incirculation.png'),
                  ),
                  SizedBox(width: Constant.SIZE_06),
                  const Text(Strings.IN_CIRCULATION),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageIcon(
                    const AssetImage('assets/icons/home.png'),
                  ),
                  SizedBox(width: Constant.SIZE_06),
                  const Text(Strings.WITH_PARTNER),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageIcon(
                    const AssetImage('assets/icons/damaged.png'),
                  ),
                  SizedBox(width: Constant.SIZE_06),
                  const Text(Strings.DAMAGED),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageIcon(
                    const AssetImage('assets/icons/sold.png'),
                  ),
                  SizedBox(width: Constant.SIZE_06),
                  const Text(Strings.SOLD),
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
                InventoryScreen(restaurantId: 2),
                IncirculationScreen(restaurantId: 2),
                Container(),
                Container(),
                Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
