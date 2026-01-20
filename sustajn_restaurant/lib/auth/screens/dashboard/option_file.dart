import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants/number_constants.dart';

class OptionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionTile({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_14),
      child: Container(
        height: Constant.CONTAINER_SIZE_130,
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).secondaryHeaderColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_14),
          border: Border.all(color: Theme.of(context).secondaryHeaderColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: Constant.CONTAINER_SIZE_30,
              color: isSelected ? Colors.black : Colors.white,
            ),
            SizedBox(height: Constant.CONTAINER_SIZE_10),
            Text(
              title,
              style: TextStyle(
                fontSize: Constant.CONTAINER_SIZE_16,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.black : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
