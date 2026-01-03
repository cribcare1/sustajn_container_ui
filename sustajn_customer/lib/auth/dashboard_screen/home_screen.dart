import '../../constants/imports_util.dart';
import '../bottom_navigationbar/bottom_navigation_bar.dart';
import 'dashboard.dart';
import 'generate_qr_screen.dart';
import 'product_screen/products_screen.dart';

class HomeScreen extends StatefulWidget {
  final int userId;
  const HomeScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _onTabChange(int index) {
    if (index == 2) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) =>  QrDialog(),
      );
      return;
    }

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const DashboardScreen(),
      ProductScreen(
        userId: widget.userId,
        onBack: () {
          _onTabChange(0);
        },
      ),
      const SizedBox(),
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
