import 'package:flutter/material.dart';
import 'package:sustajn_customer/profile_screen/history_screen/returned_tab.dart';
import 'package:sustajn_customer/profile_screen/history_screen/sold_tab.dart';

import '../../common_widgets/custom_back_button.dart';
import '../../common_widgets/filter_screen.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../utils/theme_utils.dart';
import 'borrowed_tab.dart';

class HistoryHomeScreen extends StatefulWidget {
  final int userId;

  const HistoryHomeScreen({super.key, required this.userId});

  @override
  State<HistoryHomeScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<HistoryHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: Constant.MAX_LINE_3, vsync: this);
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
        centerTitle: false,
        leading: CustomBackButton(),
        title: Text(
          Strings.HISTORY,
          style: theme!.textTheme.titleMedium!.copyWith(color: Colors.white),
        ),
        bottom: TabBar(
          controller: _tabController,
          dividerColor: Constant.grey.withOpacity(0.3),
          indicatorColor: Colors.amber,
          indicatorWeight: Constant.SIZE_03,
          labelColor: Colors.amber,
          unselectedLabelColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: [
            Tab(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  children: [
                    Icon(Icons.call_made_outlined),
                    SizedBox(width: Constant.SIZE_06),
                    Text(Strings.BORROWED),
                  ],
                ),
              ),
            ),
            Tab(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.call_received, size: Constant.CONTAINER_SIZE_18),
                    SizedBox(width: Constant.SIZE_06),
                    Text(Strings.RETURNED),
                  ],
                ),
              ),
            ),
            Tab(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ImageIcon(
                      const AssetImage('assets/images/img.png'),
                      size: Constant.CONTAINER_SIZE_16,
                    ),
                    SizedBox(width: Constant.SIZE_06),
                    Text(Strings.SOLD),
                  ],
                ),
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
                BorrowedTabScreen(userId: widget.userId),
                ReturnedTabScreen(userId: widget.userId),
                SoldTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
