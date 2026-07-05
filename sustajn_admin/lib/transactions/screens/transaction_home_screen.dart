import 'package:container_tracking/transactions/screens/transaction_extendedfee_screen.dart';
import 'package:container_tracking/transactions/screens/transaction_sold_screens.dart';
import 'package:container_tracking/transactions/screens/transaction_subscription_screen.dart';
import 'package:flutter/material.dart';
import '../../../common_widgets/custom_back_button.dart';
import '../../../constants/number_constants.dart';
import '../../../constants/string_utils.dart';
import '../../../utils/theme_utils.dart';

class TransactionHomeScreen extends StatefulWidget {
  final int? userId;

  const TransactionHomeScreen({super.key, required this.userId});

  @override
  State<TransactionHomeScreen> createState() => _TransactionHomeScreenState();
}

class _TransactionHomeScreenState extends State<TransactionHomeScreen>
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
        backgroundColor: theme.primaryColor,
        elevation: 0,
        centerTitle: false,
        leading: CustomBackButton(),
        title: Text(
          Strings.TRANSACTIONS,
          style: theme.textTheme.titleMedium!.copyWith(color: Colors.white),
        ),
        bottom: TabBar(
          controller: _tabController,
          dividerColor: Constant.grey.withOpacity(0.3),
          indicatorColor: Colors.amber,
          indicatorWeight: 3,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: Colors.amber,
          unselectedLabelColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min, // ✅ important
                children: [
                  Image.asset(
                    Strings.SUBSCRIPTION_IMG,
                    height: 14,
                    width: 14,
                  ),
                  const SizedBox(width: 1.8),
                  const Text("Subscription"),
                ],
              ),
            ),

            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    Strings.SOLD_IMG,
                    height:14,
                    width: 14,
                  ),
                  const SizedBox(width: 1.8),
                  const Text("Sold"),
                ],
              ),
            ),

            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    Strings.CLOCK_IMG,
                    height:14,
                    width:14,
                  ),
                  const SizedBox(width: 1.8),
                  const Text("Extended Fee"),
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
                TransactionSubscriptionScreen(userId: widget.userId!),
                TransactionSoldScreen(userId: widget.userId!),
                TransactionExtendedFeeScreen(userId: widget.userId!),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
