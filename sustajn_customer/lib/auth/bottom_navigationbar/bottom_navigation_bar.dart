import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import '../dashboard_screen/dashboard_screen.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
  });

  void _handleNavigation(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget target;

    switch (index) {
      case 0:
        target = const DashboardScreen();
        break;
      case 1:
        target = const Scaffold();
        break;
      case 2:
        target = const Scaffold();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => target),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      top: false,
      child: SizedBox(
        height: 90,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 65,
                decoration: const BoxDecoration(
                  color: Color(0xFFD6B24C),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(22),
                    topRight: Radius.circular(22),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavItem(
                      icon: Icons.home_filled,
                      label: "Home",
                      isSelected: currentIndex == 0,
                      onTap: () => _handleNavigation(context, 0),
                    ),

                    SizedBox(width: width * 0.22),

                    _NavItem(
                      icon: Icons.search,
                      label: "Search Restaurants",
                      isSelected: currentIndex == 1,
                      onTap: () => _handleNavigation(context, 1),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              top: -28,
              left: width / 2 - 30,
              child: GestureDetector(
                onTap: () => _handleNavigation(context, 2),
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD6B24C),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: const Icon(
                    Icons.qr_code_scanner,
                    size: 28,
                    color: Color(0xFF0E3B2E),
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 8,
              left: width / 2 - 20,
              child: Container(
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF0E3B2E),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? const Color(0xFF0E3B2E) : Colors.transparent,
            ),
            child: Icon(
              icon,
              size: 22,
              color: isSelected ? Colors.white : const Color(0xFF0E3B2E),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.black : const Color(0xFF0E3B2E),
            ),
          ),
        ],
      ),
    );
  }
}
