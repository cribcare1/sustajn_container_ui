import 'package:flutter/material.dart';

import '../../../constants/number_constants.dart';
import '../../../container_list/container_list_screen.dart';
import '../../../container_request/container_request_screen.dart';
import '../../../customer/screens/customer_list_screen.dart';
import '../../../history/screens/history_screen.dart';
import '../../../resutants/screens/resturant_list_screen.dart';
import '../../../utils/theme_utils.dart';
import '../dashboard_screen.dart';
import '../profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final themeData = CustomTheme.getTheme(true);
    return Scaffold(
      body: _getCurrentScreen(),
      bottomNavigationBar: Container(
        // height: Constant.CONTAINER_SIZE_70,
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
              icon: Icon(Icons.home),
              label: 'Resturants',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.group),
                label: 'Customers'),
          ],
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
        return RestaurantListScreen();
    }
  }
}
