import 'package:flutter/material.dart';

import '../../../constants/number_constants.dart';
import '../profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
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
        height: Constant.CONTAINER_SIZE_70,
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
          selectedItemColor:  Color(0xff6eac9e),
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: TextStyle(
            fontSize: Constant.LABEL_TEXT_SIZE_14,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: Constant.LABEL_TEXT_SIZE_14,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.request_page),
              label: 'Request',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _getCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return _buildRequestTab();
      case 2:
        return _buildHistoryTab();
      case 3:
        return _buildProfileTab();
      default:
        return _buildHomeTab();
    }
  }

  Widget _buildHomeTab() {
    return Column(
      children: [
      ],
    );
  }

  Widget _buildRequestTab() {
    return Padding(
      padding: EdgeInsets.all(Constant.PADDING_HEIGHT_10),
    );
  }

  Widget _buildHistoryTab() {
    return Padding(
      padding: EdgeInsets.all(Constant.PADDING_HEIGHT_10),
      child: Column(
        children: [
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return ProfileScreen();
  }

}