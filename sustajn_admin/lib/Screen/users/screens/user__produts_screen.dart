import 'package:container_tracking/Screen/Partner/screens/receive_screen.dart';
import 'package:container_tracking/Screen/users/screens/user_active_screen.dart';
import 'package:container_tracking/Screen/users/screens/user_borrowed_screen.dart';
import 'package:container_tracking/Screen/users/screens/user_returned_screen.dart';
import 'package:flutter/material.dart';

import '../../../common_widgets/custom_back_button.dart';
import '../../../constants/number_constants.dart';

import '../../../constants/string_utils.dart';
import '../../../utils/theme_utils.dart';
import 'user_active_screen.dart';
import 'user_borrowed_screen.dart';

class UserProductsHomeScreen extends StatefulWidget {
  final int? userId;

  const UserProductsHomeScreen({super.key, required this.userId});

  @override
  State<UserProductsHomeScreen> createState() => _UserProductsHomeScreenState();
}

class _UserProductsHomeScreenState extends State<UserProductsHomeScreen>
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
          Strings.PRODUCTS,
          style: theme.textTheme.titleMedium!.copyWith(color: Colors.white),
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
                mainAxisSize: MainAxisSize.min, // ✅ important
                children: [
                  Image.asset(
                    Strings.BOWL_IMG,
                    height: 15,
                    width: 15,
                  ),
                  const SizedBox(width: 2),
                  const Text("Active"),
                ],
              ),
            ),

            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.call_made_outlined, size: 15),
                  const SizedBox(width: 2),
                  const Text("Borrowed"),
                ],
              ),
            ),

            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.call_received_outlined, size: 15),
                  const SizedBox(width: 2),
                  const Text("Returned"),
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
                UsersActiveScreen(userId: widget.userId!),
                UsersBorrowedScreen(userId: widget.userId!),
                UserReturnedScreen(userId: widget.userId!),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
