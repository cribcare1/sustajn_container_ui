import 'package:flutter/material.dart';

import '../../constants/number_constants.dart';

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

    return SafeArea(
      top: false,
      child: SizedBox(
        height: Constant.CONTAINER_SIZE_90,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: Constant.CONTAINER_SIZE_65,
                decoration:  BoxDecoration(
                  color: Color(0xFFD6B24C),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Constant.CONTAINER_SIZE_22),
                    topRight: Radius.circular(Constant.CONTAINER_SIZE_22),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavItem(
                      icon: Icons.home_filled,
                      label: "Home",
                      isSelected: currentIndex == 0,
                      onTap: () => onTabChange(0),
                    ),

                    SizedBox(width: width * 0.22),

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

            Positioned(
              top: -28,
              left: width / 2 - 30,
              child: GestureDetector(
                onTap: () => onTabChange(2),
                child: Container(
                  height: Constant.CONTAINER_SIZE_60,
                  width: Constant.CONTAINER_SIZE_60,
                  decoration: BoxDecoration(
                    color:  Color(0xFFD6B24C),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: Constant.SIZE_04),
                  ),
                  child: const Icon(
                    Icons.qr_code_scanner,
                    size: 28,
                    color: Color(0xFF0E3B2E),
                  ),
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
            padding:  EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_14, vertical: Constant.SIZE_08),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? const Color(0xFF0E3B2E)
                  : Colors.transparent,
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
