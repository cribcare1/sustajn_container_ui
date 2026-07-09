import 'package:flutter/material.dart';

import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';

class PartnerRemarksBottomSheet extends StatelessWidget {
  const PartnerRemarksBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF0E3B2E),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Constant.CONTAINER_SIZE_24),
        ),
      ),
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: Constant.CONTAINER_SIZE_40,
                height: Constant.CONTAINER_SIZE_40,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          SizedBox(height: Constant.SIZE_05),

          Text(
            Strings.PARTNER_REMARKS,
            style: themeData.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: Constant.CONTAINER_SIZE_20),

          Text(
            Strings.REMARK_DETAILS,
            style: themeData.textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
              height: 1.5,
            ),
          ),

          SizedBox(height: Constant.CONTAINER_SIZE_25),
        ],
      ),
    );
  }
}