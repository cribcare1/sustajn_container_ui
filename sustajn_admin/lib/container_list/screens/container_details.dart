import 'dart:io';
import 'package:container_tracking/container_list/screens/total_list_screen.dart';
import 'package:flutter/material.dart';

import '../../common_widgets/custom_app_bar.dart';
import '../../common_widgets/custom_back_button.dart';
import '../../common_widgets/filter_screen_2.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utility.dart';

class ContainerDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> containerData;

  ContainerDetailsScreen({
    super.key,
    required this.containerData,
  });


  final List<Map<String, dynamic>> items = [
    {
      "name": "The Velvet Table",
      "address": "Al Marsa Street 57, Dubai Marina",
      "date": "25/11/2025",
      "amount": 200,
    },
    {
      "name": "Masala Chowk",
      "address": "Apartment 1203, Al Safa Tower",
      "date": "21/11/2025",
      "amount": 100,
    },
    {
      "name": "The Bombay Canteen",
      "address": "Villa 7, Jumeirah Beach Residence",
      "date": "14/11/2025",
      "amount": 300,
    },
  ];

  final List<Map<String, dynamic>> totalReturnedItems = [
    {
      "name": "The Velvet Table",
      "address": "Al Marsa Street 57, Dubai Marina",
      "date": "25/11/2025",
      "amount": 200,
    },
    {
      "name": "Masala Chowk",
      "address": "Apartment 1203, Al Safa Tower",
      "date": "21/11/2025",
      "amount": 100,
    },
    {
      "name": "The Bombay Canteen",
      "address": "Villa 7, Jumeirah Beach Residence",
      "date": "14/11/2025",
      "amount": 300,
    },
  ];

  final GlobalKey _menuKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final themeData = CustomTheme.getTheme(true);
    return Scaffold(
      backgroundColor: themeData?.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: Strings.CONTAINER_DETAILS,
        action: [
        IconButton(
        key: _menuKey,
        icon: const Icon(Icons.more_vert),
        onPressed: () {
          Utils.showEditDeleteMenu(
            context: context,
            iconKey: _menuKey,
            onEdit: () {
              print("Edit clicked");
            },
            onDelete: () {
              print("Delete clicked");
            },
          );
        },
      )

      ],
        leading: CustomBackButton(),
      ).getAppBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildContainerHeader(context, themeData!),
              SizedBox(height: Constant.CONTAINER_SIZE_20),

              _buildAvailableContainerCard(context, themeData),
              SizedBox(height: Constant.CONTAINER_SIZE_20),

              _buildIssuedReturnedRow(context, themeData),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContainerHeader(BuildContext context, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_14),
      decoration: BoxDecoration(
        color: const Color(0xFF256C51),
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
            child: containerData["image"] != null
                ? Image.file(
              containerData["image"] as File,
              width: Constant.CONTAINER_SIZE_60,
              height: Constant.CONTAINER_SIZE_60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildPlaceholderImage();
              },
            )
                : _buildPlaceholderImage(),
          ),
          SizedBox(width: Constant.CONTAINER_SIZE_16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  containerData["name"]?.toString() ?? 'Unnamed Container',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: Constant.LABEL_TEXT_SIZE_16,
                  ),
                ),
                SizedBox(height: Constant.SIZE_04),
                Text(
                  containerData["id"]?.toString() ?? 'No ID',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                    fontSize: Constant.LABEL_TEXT_SIZE_14,
                  ),
                ),
                Text(
                  "${containerData["volume"]?.toString() ?? '0'}ml",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                    fontSize: Constant.LABEL_TEXT_SIZE_14,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "₹${containerData["price"]?.toString() ?? "30"}",
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: Constant.LABEL_TEXT_SIZE_18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableContainerCard(BuildContext context, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
           Strings.AVAILABLE_CONTAINERS,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: Constant.LABEL_TEXT_SIZE_16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: Constant.CONTAINER_SIZE_10),
          Text(
            containerData["available"]?.toString() ?? containerData["quantity"]?.toString() ?? "0",
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: Constant.LABEL_TEXT_SIZE_20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIssuedReturnedRow(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        Expanded(child: _buildIssuedCard(context, theme)),
        SizedBox(width: Constant.CONTAINER_SIZE_12),
        Expanded(child: _buildReturnedCard(context, theme)),
      ],
    );
  }

  Widget _buildIssuedCard(BuildContext context, ThemeData theme) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TotalListScreen(
              title: Strings.TOTAL_ISSUED_TITLE,
              searchHint: Strings.SEARCH_BY_RESTURANT,
              monthTitle: "November - 2025",
              totalAmount: 1000,
              items: items,
              onTap: (){
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => ReusableFilterBottomSheet(
                    title: "Filters",
                    leftTabTitle: "Month",
                    options: [
                      "December–2024",
                      "January–2025",
                      "February–2024",
                      "March–2024",
                      "Apiral–2024",
                      "May–2024",
                      "June–2024",
                      "July–2024",
                      "August–2024",
                      "September–2025",
                      "October–2025",
                      "November–2025",
                    ],
                    selectedValue: "January–2025",
                    onApply: (value) {
                      print("Selected Month = $value");
                    },
                  ),
                );

              },
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Strings.TOTAL_ISSUED_TITLE,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: Constant.LABEL_TEXT_SIZE_16,
                  ),
                ),
                _buildArrowButton(),
              ],
            ),
            SizedBox(height: Constant.CONTAINER_SIZE_12),
            Text(
              containerData["issued"]?.toString() ?? "0",
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: Constant.LABEL_TEXT_SIZE_22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReturnedCard(BuildContext context, ThemeData theme) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TotalListScreen(
              title: Strings.TOTAL_RETURNED,
              searchHint: Strings.SEARCH_BY_RESTURANT,
              monthTitle: "November - 2025",
              totalAmount: 1000,
              items: totalReturnedItems,
              onTap: (){
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => ReusableFilterBottomSheet(
                    title: "Filters",
                    leftTabTitle: "Month",
                    options: [
                      "December–2024",
                      "January–2025",
                      "February–2024",
                      "March–2024",
                      "Apiral–2024",
                      "May–2024",
                      "June–2024",
                      "July–2024",
                      "August–2024",
                      "September–2025",
                      "October–2025",
                      "November–2025",
                    ],
                    selectedValue: "January–2025",
                    onApply: (value) {
                      print("Selected Month = $value");
                    },
                  ),
                );

              },
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Strings.TOTAL_RETURNED,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: Constant.LABEL_TEXT_SIZE_16,
                  ),
                ),
                _buildArrowButton(),
              ],
            ),
            SizedBox(height: Constant.CONTAINER_SIZE_12),
            Text(
              containerData["returned"]?.toString() ?? "0",
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: Constant.LABEL_TEXT_SIZE_22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: Constant.CONTAINER_SIZE_60,
      height: Constant.CONTAINER_SIZE_60,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
      ),
      child: Icon(
        Icons.image,
        color: Colors.white.withOpacity(0.7),
        size: Constant.CONTAINER_SIZE_28,
      ),
    );
  }

  Widget _buildArrowButton() {
    return Container(
      padding: EdgeInsets.all(Constant.SIZE_06),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFEFF7F1),
      ),
      child:  Icon(Icons.arrow_outward, size: Constant.CONTAINER_SIZE_18),
    );
  }
}