import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common_widgets/custom_app_bar.dart';
import '../common_widgets/custom_back_button.dart';
import '../common_widgets/filter_bottom_sheet.dart';
import '../constants/number_constants.dart';
import '../utils/theme_utils.dart';
import 'container_details.dart';

class ContainerListScreen extends ConsumerStatefulWidget {
  final String title;
  const ContainerListScreen({super.key, required this.title});

  @override
  ConsumerState<ContainerListScreen> createState() => _ContainerCountDetailsState();
}

class _ContainerCountDetailsState extends ConsumerState<ContainerListScreen> {

  final List<Map<String, String>> items = [
    {
      "image": "assets/images/cups.png",
      "name": "Dip Cups",
      "code": "ST-DC-50",
      "size": "50ml",
      "qty": "1,000",
    },
    {
      "image": "assets/images/cups.png",
      "name": "Dip Cups",
      "code": "ST-DC-70",
      "size": "70ml",
      "qty": "500",
    },
    {
      "image": "assets/images/cups.png",
      "name": "Dip Cups",
      "code": "ST-DC-80",
      "size": "80ml",
      "qty": "400",
    },
    {
      "image": "assets/images/cups.png",
      "name": "Round Bowl",
      "code": "ST-DC-450",
      "size": "450ml",
      "qty": "300",
    },
    {
      "image": "assets/images/cups.png",
      "name": "Round Bowl",
      "code": "ST-DC-900",
      "size": "900ml",
      "qty": "200",
    },
    {
      "image": "assets/images/cups.png",
      "name": "Rectangular Container",
      "code": "ST-RC-600",
      "size": "600ml",
      "qty": "500",
    },
    {
      "image": "assets/images/cups.png",
      "name": "Rectangular Container",
      "code": "ST-DC-100",
      "size": "100ml",
      "qty": "500",
    },
  ];
  List<Map<String, String>> filteredItems = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredItems = items;
  }

  void _filterItems(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      filteredItems = items.where((item) {
        final name = item['name']!.toLowerCase();
        final code = item['code']!.toLowerCase();
        return name.contains(lowerQuery) || code.contains(lowerQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = CustomTheme.getTheme(true);
    return Scaffold(
      appBar: CustomAppBar(
        leading: CustomBackButton(),
        title: widget.title,
        action: [
          IconButton(onPressed: () {
            showFilterSheet(context);
          }, icon: Icon(Icons.filter_list)),
        ],
      ).getAppBar(context),

      body: Padding(
        padding:  EdgeInsets.all(Constant.CONTAINER_SIZE_16),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: _filterItems,
              decoration: InputDecoration(
                hintText: "Search containers",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                itemCount: items.length,
                separatorBuilder: (context, index) =>
                    Divider(
                      height: Constant.SIZE_00,
                      thickness: 1,
                      color: Colors.grey[300],
                    ),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _buildContainerTile(
                      item, theme!,

                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildContainerTile(Map<String, dynamic> item, ThemeData themeData) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
        MaterialPageRoute(builder: (context)=> ContainersDetailsScreen()));
      },
      child: Container(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
        decoration: BoxDecoration(
          color: themeData.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(item["image"]??" ", width: 55, height: 55, fit: BoxFit.cover,),
            ),
            SizedBox(width: Constant.CONTAINER_SIZE_14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item["name"]?.toString() ?? 'Unnamed',
                    style: TextStyle(
                      fontSize: Constant.LABEL_TEXT_SIZE_16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: Constant.SIZE_04),
                  Text(
                    item["code"]?.toString() ?? 'No ID',
                    style: TextStyle(fontSize: Constant.LABEL_TEXT_SIZE_14,
                        color: Colors.grey),
                  ),
                  Text(
                    "${item["size"]?.toString() ?? '0'}",
                    style: TextStyle(fontSize: Constant.LABEL_TEXT_SIZE_14,
                        color: Colors.grey),
                  ),
                ],
              ),
            ),
            Text(
              item["qty"]?.toString() ?? '0',
              style: TextStyle(
                fontSize: Constant.LABEL_TEXT_SIZE_18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: Constant.SIZE_10),
            Icon(Icons.arrow_forward_ios, size: Constant.CONTAINER_SIZE_16,
                color: Colors.grey),
          ],
        ),

      ),
    );
  }


  void showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const FilterBottomSheet(),
    );
  }
}