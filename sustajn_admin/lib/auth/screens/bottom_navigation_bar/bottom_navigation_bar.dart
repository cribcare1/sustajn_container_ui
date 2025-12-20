import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants/number_constants.dart';
import '../../../container_list/screens/container_list_screen.dart';
import '../../../customer/screens/customer_list_screen.dart';
import '../../../resutants/screens/resturant_list_screen.dart';
import '../../../utils/theme_utils.dart';
import '../dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  Future<bool> _onWillPop() async {
    if (_currentIndex != 0) {
      setState(() => _currentIndex = 0);
      return false;
    }

    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Exit App"),
        content: const Text("Do you want to exit the app?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Yes"),
          ),
        ],
      ),
    );

    if (shouldExit == true) {
      SystemNavigator.pop();
      return true;
    }

    return false;
  }
  @override
  Widget build(BuildContext context) {
    final themeData = CustomTheme.getTheme(true);
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Scaffold(
        body: _getCurrentScreen(),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.grey.shade300,
                width: Constant.SIZE_01,
              ),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: themeData!.secondaryHeaderColor,
            selectedItemColor: themeData.primaryColor,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: TextStyle(fontSize: Constant.LABEL_TEXT_SIZE_14),
            unselectedLabelStyle: TextStyle(
              fontSize: Constant.LABEL_TEXT_SIZE_14,
            ),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home),
                  label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.rice_bowl),
                label: 'Containers',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.set_meal_outlined),
                label: 'Restaurants',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.group),
                  label: 'Customers'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getCurrentScreen() {
    return _buildCurrentTabContent();
  }

  Widget _buildCurrentTabContent() {
    switch (_currentIndex) {
      case 0:
        return DashboardScreen();
      case 1:
        return ContainersScreen();
      case 2:
        return RestaurantListScreen();
      case 3:
        return CustomerListScreen();
      default:
        return DashboardScreen();
    }
  }
}
