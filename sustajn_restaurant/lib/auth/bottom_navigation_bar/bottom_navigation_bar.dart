import 'package:flutter/material.dart';

import '../../../constants/number_constants.dart';
import '../../../container_request/container_request_screen.dart';
import '../screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          backgroundColor: Color(0xffb3dbff),
          selectedItemColor: Color(0xff6eac9e),
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: TextStyle(fontSize: Constant.LABEL_TEXT_SIZE_14),
          unselectedLabelStyle: TextStyle(
            fontSize: Constant.LABEL_TEXT_SIZE_14,
          ),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.request_page),
              label: 'Request',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
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
        return Container();
      case 1:
        return ContainerRequestScreen();
      case 2:
        return Container();
      case 3:
        return ProfileScreen();
      default:
        return Container();
    }
  }
}