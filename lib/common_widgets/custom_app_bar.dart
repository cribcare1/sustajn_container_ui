import 'package:flutter/material.dart';

import '../utils/theme_utils.dart';

class CustomAppBar {
   String? title;
  final List<Widget>? action;
  final PreferredSize? bottom;
  bool? centerTitle;
  final Widget leading;

  CustomAppBar({
    this.title,
    this.action,
    this.bottom,
    this.centerTitle = false,
    required this.leading,
  });

  PreferredSizeWidget getAppBar(BuildContext context) {
    final themeData = CustomTheme.getTheme(true);
    return AppBar(
      backgroundColor: themeData!.primaryColor,
      surfaceTintColor: themeData.primaryColor,
      centerTitle: false,
      elevation: 0,
      title: Text(
        title??"",
        style: Theme.of(
          context,
        ).textTheme.titleMedium!.copyWith(color: Colors.white),
      ),
      // leadingWidth: 30,
      actions: action,
      bottom: bottom,
      leading: leading,
    );
  }
}
