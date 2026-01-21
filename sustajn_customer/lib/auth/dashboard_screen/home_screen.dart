import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/imports_util.dart';
import '../../provider/profile_provider.dart';
import '../../utils/utils.dart';
import '../bottom_navigationbar/bottom_navigation_bar.dart';
import 'dashboard.dart';
import 'generate_qr_screen.dart';
import 'product_screen/products_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final int? userId;
  const HomeScreen({Key? key,  this.userId}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  void _onTabChange(int index) {
    if (index == 2) {
      final profileState = ref.read(profileProvider);
      final profileData = profileState.profileData;

      if (profileData == null ||
          profileData.bankDetailsResponse == null) {
        showCustomSnackBar(
          context: context,
          message:
          "You have not added bank details, please add it to view the QR code",
          color: Colors.green,
        );
        return;
      }

      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => QrDialog(),
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
        userId: widget.userId!,
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
