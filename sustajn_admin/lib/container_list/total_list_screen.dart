import 'package:flutter/material.dart';
import '../common_widgets/custom_app_bar.dart';
import '../common_widgets/custom_back_button.dart';
import '../constants/number_constants.dart';
import '../utils/theme_utils.dart';

class TotalListScreen extends StatelessWidget {
  final String title;
  final String searchHint;
  final String monthTitle;
  final int totalAmount;
  final List<Map<String, dynamic>> items;

  const TotalListScreen({
    super.key,
    required this.title,
    required this.searchHint,
    required this.monthTitle,
    required this.totalAmount,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = CustomTheme.getTheme(true);
    return Scaffold(
      backgroundColor: themeData?.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: title,
        leading: CustomBackButton(),
      ).getAppBar(context),
      body: Column(
        children: [
          _buildSearchBar(context, themeData!),
          _buildMonthHeader(context, themeData),
          Expanded(child: _buildList(context, themeData)),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Constant.CONTAINER_SIZE_16,
        vertical: Constant.CONTAINER_SIZE_12,
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: searchHint,
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            fontSize: Constant.LABEL_TEXT_SIZE_14,
            color: Colors.grey.shade600,
          ),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(Icons.search, color: theme.primaryColorDark),
          suffixIcon: Icon(Icons.filter_list, color: theme.primaryColorDark),
          contentPadding: EdgeInsets.symmetric(
            vertical: Constant.CONTAINER_SIZE_14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildMonthHeader(BuildContext context, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: Constant.CONTAINER_SIZE_16,
        vertical: Constant.CONTAINER_SIZE_12,
      ),
      color: Colors.grey.shade200,
      child: Row(
        children: [
          Expanded(
            child: Text(
              monthTitle,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: Constant.LABEL_TEXT_SIZE_16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            totalAmount.toString(),
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: Constant.LABEL_TEXT_SIZE_16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, ThemeData theme) {
    return ListView.builder(
      padding: EdgeInsets.only(
        left: Constant.CONTAINER_SIZE_16,
        right: Constant.CONTAINER_SIZE_16,
        top: Constant.CONTAINER_SIZE_10,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildListTile(context, item, theme);
      },
    );
  }

  Widget _buildListTile(BuildContext context, Map<String, dynamic> item, ThemeData theme) {
    return Container(
      margin: EdgeInsets.only(bottom: Constant.CONTAINER_SIZE_20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item["name"],
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: Constant.LABEL_TEXT_SIZE_16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                item["amount"].toString(),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: Constant.LABEL_TEXT_SIZE_16,
                  fontWeight: FontWeight.bold,
                ),
              ),
               SizedBox(width: Constant.SIZE_06),
               Icon(Icons.arrow_forward_ios, size: Constant.CONTAINER_SIZE_14, color: Colors.grey),
            ],
          ),
          SizedBox(height: Constant.SIZE_06),
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: Constant.CONTAINER_SIZE_16,
                color: Colors.grey.shade600,
              ),
              SizedBox(width: Constant.SIZE_06),
              Expanded(
                child: Text(
                  item["address"],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: Constant.LABEL_TEXT_SIZE_14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Constant.SIZE_06),
          Text(
            item["date"],
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: Constant.LABEL_TEXT_SIZE_14,
              color: Colors.grey.shade700,
            ),
          ),
          Divider(
            color: Colors.grey.shade300,
            height: Constant.CONTAINER_SIZE_20,
          ),
        ],
      ),
    );
  }
}
