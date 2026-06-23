import 'package:container_tracking/common_widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

import '../../../common_widgets/custom_back_button.dart';
import '../../../common_widgets/custom_search_bar.dart';
import '../../../constants/number_constants.dart';
import '../../../constants/string_utils.dart';

class ContainerItem {
  final String name;
  final String code;
  final String size;
  final int count;
  final String type;

  ContainerItem({
    required this.name,
    required this.code,
    required this.size,
    required this.count,
    required this.type,
  });
}

class UserDamagedScreen extends StatefulWidget {
  final int userId;

  const UserDamagedScreen({super.key, required this.userId});

  @override
  State<UserDamagedScreen> createState() => _DamagedScreenState();
}

class _DamagedScreenState extends State<UserDamagedScreen> {
  List<ContainerItem> containerList = [
    ContainerItem(
      name: "Dip Cups",
      code: "ST-DC-50",
      size: "50ml",
      count: 12234,
      type: "dip",
    ),
    ContainerItem(
      name: "Round Containers",
      code: "ST-RDC-500",
      size: "500ml",
      count: 300,
      type: "round",
    ),
    ContainerItem(
      name: "Rectangular Containers",
      code: "ST-RC-800",
      size: "900ml",
      count: 600,
      type: "rectangular",
    ),
  ];

  String getContainerImage(String type) {
    switch (type) {
      case "dip":
        return "assets/images/white_container.png";
      case "round":
        return "assets/images/round_container.png";
      case "rectangular":
        return "assets/images/rectangular_container.png";
      default:
        return "assets/images/cups.png";
    }
  }

  List<ContainerItem> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = containerList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0E3B2E),
      appBar: CustomAppBar(
        title: "Damaged",
        leading: CustomBackButton(),
      ).getAppBar(context),
      body: SafeArea(
        child: Column(
          children: [
            CustomSearchBar(
              hintText: Strings.SEARCH_CONTAINER_NAME,
              onChanged: (value) {
                setState(() {
                  if (value.isEmpty) {
                    filteredItems = containerList;
                  } else {
                    filteredItems = containerList.where((item) {
                      return item.name.toLowerCase().contains(
                        value.toLowerCase(),
                      );
                    }).toList();
                  }
                });
              },
            ),
            SizedBox(height: Constant.CONTAINER_SIZE_16),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: Constant.CONTAINER_SIZE_16,
                ),
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return _cardItem(item);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _filterButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _cardItem(ContainerItem item) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: Constant.CONTAINER_SIZE_12),
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1F5A46), Color(0xFF0E3B2E)],
        ),
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_14),
        border: Border.all(color: Colors.white70),
      ),
      child: Row(
        children: [
          Container(
            height: Constant.CONTAINER_SIZE_50,
            width: Constant.CONTAINER_SIZE_50,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_10),
            ),
            child: Image.asset(getContainerImage(item.type)),
          ),
          SizedBox(width: Constant.CONTAINER_SIZE_12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: Constant.SIZE_04),
                Text(
                  item.code,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: Constant.CONTAINER_SIZE_12,
                  ),
                ),
                Text(
                  item.size,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: Constant.CONTAINER_SIZE_11,
                  ),
                ),
              ],
            ),
          ),

          Row(
            children: [
              Text(
                item.count.toString(),
                style: TextStyle(
                  color: theme.secondaryHeaderColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: Constant.SIZE_06),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white54,
                size: Constant.CONTAINER_SIZE_14,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _filterButton() {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Constant.CONTAINER_SIZE_18,
        vertical: Constant.CONTAINER_SIZE_12,
      ),
      decoration: BoxDecoration(
        color: theme.secondaryHeaderColor,
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                Icon(
                  Icons.sort,
                  color: Colors.black,
                  size: Constant.CONTAINER_SIZE_20,
                ),
                SizedBox(width: Constant.SIZE_06),
                Text(
                  Strings.SORT,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: Constant.CONTAINER_SIZE_12,
            ),
            height: Constant.CONTAINER_SIZE_18,
            width: Constant.SIZE_02,
            color: Colors.black26,
          ),

          InkWell(
            onTap: () {},
            child: Row(
              children: [
                Icon(
                  Icons.filter_list,
                  color: Colors.black,
                  size: Constant.CONTAINER_SIZE_20,
                ),
                SizedBox(width: Constant.SIZE_06),
                Text(
                  Strings.FILTER,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
