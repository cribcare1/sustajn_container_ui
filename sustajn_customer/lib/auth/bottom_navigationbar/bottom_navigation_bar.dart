import 'package:flutter/material.dart';

import '../../constants/number_constants.dart';
import '../../utils/theme_utils.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabChange;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final size = MediaQuery.of(context).size.width;
    var theme = CustomTheme.getTheme(true);

    return SafeArea(
      top: false,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.12,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            /// Main Curved Background
            ClipPath(
              clipper: BottomNavClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.09,

                width: double.infinity,
                color: Constant.gold,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavItem(
                      icon: Icons.home_filled,
                      label: "Home",
                      isSelected: currentIndex == 0,
                      onTap: () => onTabChange(0),
                    ),

                    SizedBox(width: width * 0.20),

                    _NavItem(
                      imageAsset: 'assets/images/img.png',
                      label: "Products",
                      isSelected: currentIndex == 1,
                      onTap: () => onTabChange(1),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(bottom: Constant.CONTAINER_SIZE_45),
              child: Positioned(
                top: 0,
                child: GestureDetector(
                  onTap: () => onTabChange(2),
                  child: Container(
                    height: size * 0.15,
                    width: size * 0.15,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Constant.gold,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(
                      Icons.qr_code_scanner,
                      size: Constant.CONTAINER_SIZE_30,
                      color: theme!.scaffoldBackgroundColor,
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: Constant.SIZE_08,
              child: Container(
                height: Constant.SIZE_04,
                width: Constant.CONTAINER_SIZE_120,
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(Constant.SIZE_10),
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
  final IconData? icon;
  final String? imageAsset;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    this.icon,
    this.imageAsset,
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
            padding: EdgeInsets.symmetric(
              horizontal: Constant.CONTAINER_SIZE_14,
              vertical: Constant.SIZE_08,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? const Color(0xFF0E3B2E) : Colors.transparent,
            ),
            child: imageAsset != null
                ? Image.asset(
                    imageAsset!,
                    height: Constant.CONTAINER_SIZE_22,
                    width: Constant.CONTAINER_SIZE_22,
                    color: isSelected ? Colors.white : const Color(0xFF0E3B2E),
                  )
                : Icon(
                    icon,
                    size: Constant.CONTAINER_SIZE_22,
                    color: isSelected ? Colors.white : const Color(0xFF0E3B2E),
                  ),
          ),
          SizedBox(height: Constant.SIZE_02),
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

class BottomNavClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    final double width = size.width;
    final double height = size.height;
    final double center = width / 2;

    // Wider + deeper curve (UX match)
    final double curveWidth = width * 0.14;
    final double curveDepth = height * 0.50;

    path.lineTo(center - curveWidth, 0);

    /// Left smooth curve
    path.quadraticBezierTo(
      center - curveWidth * 0.75,
      0,
      center - curveWidth * 0.55,
      curveDepth * 0.45,
    );

    /// Deep center curve
    path.quadraticBezierTo(
      center,
      curveDepth,
      center + curveWidth * 0.55,
      curveDepth * 0.45,
    );

    /// Right smooth curve
    path.quadraticBezierTo(
      center + curveWidth * 0.75,
      0,
      center + curveWidth,
      0,
    );
    path.lineTo(width, 0);
    path.lineTo(width, height);
    path.lineTo(0, height);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
