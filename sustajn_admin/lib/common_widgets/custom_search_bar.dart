import 'package:flutter/material.dart';

import '../constants/number_constants.dart';

class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;
  final VoidCallback? onFilterTap;
  final TextEditingController? controller;

  const CustomSearchBar({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.onFilterTap,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_14),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        ),
        child: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.white70),
            prefixIcon: const Icon(Icons.search, color: Colors.white),

            // ✅ optional filter icon
            suffixIcon: onFilterTap != null
                ? IconButton(
              icon: const Icon(Icons.filter_list, color: Colors.white),
              onPressed: onFilterTap,
            )
                : null,

            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: Constant.CONTAINER_SIZE_12),
          ),
        ),
      ),
    );
  }
}