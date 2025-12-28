import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/number_constants.dart';
import '../../utils/theme_utils.dart';
import '../models/add_container_model.dart';
import 'add_container_dialog.dart';

class AddContainerScreen extends StatefulWidget {
  const AddContainerScreen({super.key});

  @override
  State<AddContainerScreen> createState() => _AddContainerScreenState();
}

class _AddContainerScreenState extends State<AddContainerScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<ContainerItem> containers = [
    ContainerItem(
      name: "Dip Cup",
      code: "ST-DC-50",
      volume: "50ml",
      availableQty: 165,
      image: "assets/images/cups.png",
    ),
    ContainerItem(
      name: "Dip Cup",
      code: "ST-DC-70",
      volume: "70ml",
      availableQty: 165,
      image: "assets/images/cups.png",
    ),
    ContainerItem(
      name: "Round Container",
      code: "ST-RDC-500",
      volume: "500ml",
      availableQty: 165,
      image: "assets/images/cups.png",
    ),
    ContainerItem(
      name: "Rectangular Container",
      code: "ST-RC-800",
      volume: "800ml",
      availableQty: 165,
      image: "assets/images/cups.png",
    ),
  ];
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      bottom: true,top: false,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Padding(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
          child: Column(
            children: [
              CustomTheme.searchField(searchController, "Search Container by Name"),
              const SizedBox(height: 10),

              Expanded(
                child: ListView.separated(
                  itemCount: containers.length,
                  separatorBuilder: (_, __) =>
                      SizedBox(height: Constant.CONTAINER_SIZE_12),
                  itemBuilder: (context, index) {
                    return _containerCard(
                      context,
                      containers[index],
                      theme,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget _containerCard(
      BuildContext context, ContainerItem item, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
      decoration: BoxDecoration(
        color: Constant.grey.withOpacity(0.2),
        borderRadius:
        BorderRadius.circular(Constant.CONTAINER_SIZE_12),
        border: Border.all(
          color: Constant.grey.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: Constant.CONTAINER_SIZE_50,
            height: Constant.CONTAINER_SIZE_50,
            decoration: BoxDecoration(
              color: Constant.white.withOpacity(0.2),
              borderRadius:
              BorderRadius.circular(Constant.CONTAINER_SIZE_12),
            ),
            child: Image.asset(item.image, fit: BoxFit.contain),
          ),

          SizedBox(width: Constant.CONTAINER_SIZE_12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white
                    )),
                SizedBox(height: Constant.SIZE_04),
                Text(item.code,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white
                    )),
                SizedBox(height: Constant.SIZE_04),
                Text(item.volume,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white70
                    )),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("Available Qty",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white
                  )),
              Text(item.availableQty.toString(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white
                  )),

              SizedBox(height: Constant.SIZE_06),

              GestureDetector(
                onTap: () => _openAddDialog(context, item),
                child: item.isAdded
                    ? Row(
                  children: [

                    Text("Remove",
                        style: theme.textTheme.bodySmall?.copyWith(
                            color:
                            Colors.white)),
                    SizedBox(width: Constant.SIZE_04),
                    Icon(Icons.close,
                        size: Constant.CONTAINER_SIZE_14,
                        color: Colors.white),

                  ],
                )
                    : Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Constant.CONTAINER_SIZE_20,
                    vertical: Constant.SIZE_04,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        Constant.CONTAINER_SIZE_20),
                    border: Border.all(
                        color: Constant.gold),
                  ),
                  child: Text(
                    "Add",
                    style: theme.textTheme.bodySmall?.copyWith(
                        color:
                        Constant.gold),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _openAddDialog(BuildContext context, ContainerItem item) async {
    final result = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => Padding(
        padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AddContainerDialog(item: item),
      ),
    );

    if (result != null && result > 0) {
      setState(() {
        item.selectedQty = result;
        item.isAdded = true;
      });
    }
  }
}
