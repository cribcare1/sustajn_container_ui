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

class SoldScreen extends StatefulWidget {
  final int restaurantId;

  const SoldScreen({super.key, required this.restaurantId});

  @override
  State<SoldScreen> createState() => _SoldScreenState();
}

class _SoldScreenState extends State<SoldScreen> {
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
      case Strings.DIP:
        return Strings.WHITE_CONTAINER;
      case Strings.ROUND:
        return Strings.ROUND_CONTAINER;
      case Strings.RECTANGULAR:
        return Strings.RECTANGULAR_CONTAINER;
      default:
        return Strings.CUP_IMG;
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
      backgroundColor: Constant.PrimaryColor,
      appBar: CustomAppBar(
        title: Strings.SOLD,
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
          colors: [Constant.green7, Constant.green8],
        ),
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_14),
        border: Border.all(color: Constant.white4),
      ),
      child: Row(
        children: [
          Container(
            height: Constant.CONTAINER_SIZE_50,
            width: Constant.CONTAINER_SIZE_50,
            decoration: BoxDecoration(
              color: Constant.PrimaryDarkColor,
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
                    color: Constant.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: Constant.SIZE_04),
                Text(
                  item.code,
                  style: TextStyle(
                    color: Constant.white3,
                    fontSize: Constant.CONTAINER_SIZE_12,
                  ),
                ),
                Text(
                  item.size,
                  style: TextStyle(
                    color: Constant.white3,
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
                color: Constant.white4,
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
                  color: Constant.black,
                  size: Constant.CONTAINER_SIZE_20,
                ),
                SizedBox(width: Constant.SIZE_06),
                Text(
                  Strings.SORT,
                  style: TextStyle(
                    color: Constant.black,
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
            color: Constant.black,
          ),

          InkWell(
            onTap: () {},
            child: Row(
              children: [
                Icon(
                  Icons.filter_list,
                  color: Constant.black,
                  size: Constant.CONTAINER_SIZE_20,
                ),
                SizedBox(width: Constant.SIZE_06),
                Text(
                  Strings.FILTER,
                  style: TextStyle(
                    color: Constant.black,
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
