import 'package:flutter/material.dart';
import 'package:sustajn_restaurant/common_widgets/custom_app_bar.dart';
import 'package:sustajn_restaurant/common_widgets/custom_back_button.dart';
import '../constants/number_constants.dart';
import 'models/assigned_container_list.dart';

class AssignedContainerListScreen extends StatelessWidget {
  final String title;
  final List<AssignedContainerItem> items;

  const AssignedContainerListScreen({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(title: title,
          leading:CustomBackButton() ).getAppBar(context),
      body: ListView(
        padding: EdgeInsets.only(
          bottom: Constant.CONTAINER_SIZE_16,
        ),
        children: _buildGroupedList(context),
      ),
    );
  }

  List<Widget> _buildGroupedList(BuildContext context) {
    final theme = Theme.of(context);
    final Map<String, List<AssignedContainerItem>> grouped = {};

    for (final item in items) {
      final key =
          "${_monthName(item.dateTime.month)}-${item.dateTime.year}";
      grouped.putIfAbsent(key, () => []).add(item);
    }

    return grouped.entries.map((entry) {
      final total = entry.value.fold<int>(
        0,
            (sum, e) => sum + e.quantity,
      );

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: Constant.CONTAINER_SIZE_16,
              vertical: Constant.SIZE_10,
            ),
            color: Constant.grey.withOpacity(0.2),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    entry.key,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white70
                    ),
                  ),
                ),
                Row(
                  children: [
                    Image.asset('assets/images/img.png',
                    height: Constant.CONTAINER_SIZE_16,
                    width: Constant.CONTAINER_SIZE_16,
                    color: Constant.gold,),

                    SizedBox(width: Constant.SIZE_04),
                    Text(
                      total.toString(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Constant.gold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          ...entry.value.map(
                (item) => _listItem(context, item),
          ),
        ],
      );
    }).toList();
  }

  Widget _listItem(
      BuildContext context, AssignedContainerItem item) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Constant.CONTAINER_SIZE_16,
        vertical: Constant.CONTAINER_SIZE_12,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Constant.grey.withOpacity(0.4),
            width: Constant.SIZE_01,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(item.dateTime),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70
                  ),
                ),
                SizedBox(height: Constant.SIZE_04),
                Text(
                  _formatTime(item.dateTime),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white70
                  ),
                ),
              ],
            ),
          ),

          Text(
            item.quantity.toString(),
            style: theme.textTheme.titleMedium?.copyWith(
              color: Constant.gold,
            ),
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  String _formatTime(DateTime date) {
    final hour =
    date.hour > 12 ? date.hour - 12 : date.hour;
    final period = date.hour >= 12 ? 'pm' : 'am';
    return "${hour.toString().padLeft(2, '0')}:"
        "${date.minute.toString().padLeft(2, '0')}$period";
  }
}
