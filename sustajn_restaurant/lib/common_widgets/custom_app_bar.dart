import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/theme_utils.dart';
import 'custom_back_button.dart';

class CustomAppBar {
  final String title;
  final List<Widget>? action;
  final PreferredSize? bottom;
  bool? centerTitle;
  final Widget leading;
  CustomAppBar({required this.title, this.action, this.bottom, this.centerTitle = false, required this.leading});
  PreferredSizeWidget getAppBar(BuildContext context) {
    final themeData = CustomTheme.getTheme(true);
    return AppBar(
      backgroundColor: themeData!.scaffoldBackgroundColor,
      centerTitle: true,
      elevation: 0,
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
      ),
      // leadingWidth: 30,
      actions: action,
      bottom: bottom,
      leading:leading,
    );
  }
}