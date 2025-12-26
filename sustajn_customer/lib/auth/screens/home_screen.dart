import '../../constants/imports_util.dart';
import '../bottom_navigationbar/bottom_navigation_bar.dart';
import '../dashboard_screen/dashboard.dart';
import '../dashboard_screen/products_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _onTabChange(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const DashboardScreen(),
      ProductScreen(
        onBack: () {
          _onTabChange(0);
        },
      ),
      const Scaffold(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTabChange: _onTabChange,
      ),
    );
  }
}
