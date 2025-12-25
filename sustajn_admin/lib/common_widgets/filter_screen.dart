import 'package:container_tracking/common_widgets/submit_clear_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/number_constants.dart';
import '../container_list/container_provider.dart';
import '../container_list/model/container_list_model.dart';

Future<List<InventoryData>?> showContainerFilterBottomSheet(
  BuildContext context,
  List<InventoryData> containerList,
) {
  return showModalBottomSheet<List<InventoryData>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return _ContainerFilterSheet(containerList: containerList);
    },
  );
}

class _ContainerFilterSheet extends ConsumerStatefulWidget {
  final List<InventoryData> containerList;

  const _ContainerFilterSheet({required this.containerList});

  @override
  ConsumerState<_ContainerFilterSheet> createState() =>
      _ContainerFilterSheetState();
}

class _ContainerFilterSheetState extends ConsumerState<_ContainerFilterSheet> {
  Set<String> selectedIds = {};
  TextEditingController searchController = TextEditingController();
  List<InventoryData> filteredContainers = [];

  @override
  void initState() {
    super.initState();
    filteredContainers = List.from(widget.containerList);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(containerNotifierProvider);
    return SafeArea(
      bottom: true,
      top: false,
      child: DraggableScrollableSheet(
        initialChildSize: 0.80,
        minChildSize: 0.50,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(Constant.CONTAINER_SIZE_20),
              ),
            ),
            child: Column(
              children: [
                _buildTopHandle(),
                _buildHeader(theme),
                _buildSearchField(theme),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: filteredContainers.length,
                    padding: EdgeInsets.symmetric(
                      horizontal: Constant.CONTAINER_SIZE_16,
                    ),
                    itemBuilder: (context, index) {
                      final item = filteredContainers[index];
                      return _buildContainerTile(item, theme);
                    },
                  ),
                ),
                _buildBottomButtons(theme),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopHandle() {
    return Padding(
      padding: EdgeInsets.only(
        top: Constant.CONTAINER_SIZE_12,
        bottom: Constant.CONTAINER_SIZE_10,
      ),
      child: Container(
        height: Constant.CONTAINER_SIZE_10 / 2,
        width: Constant.CONTAINER_SIZE_50,
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_10),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Constant.CONTAINER_SIZE_16,
        vertical: Constant.CONTAINER_SIZE_10,
      ),
      child: Row(
        children: [
          Text("Containers", style: Theme.of(context).textTheme.titleMedium),
          const Spacer(),
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(Constant.SIZE_08),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).secondaryHeaderColor,
              ),
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: Constant.CONTAINER_SIZE_18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Constant.CONTAINER_SIZE_16,
        vertical: Constant.CONTAINER_SIZE_10,
      ),
      child: TextField(
        controller: searchController,
        style: Theme.of(context).textTheme.titleSmall,
        onChanged: _filterSearch,
        decoration: InputDecoration(
          hintText: "Search by container name",
          hintStyle: Theme.of(context).textTheme.titleSmall,
          prefixIcon: Icon(Icons.search, color: Colors.white),
          contentPadding: EdgeInsets.zero,
          filled: true,
          fillColor: Theme.of(context).primaryColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildContainerTile(InventoryData item, ThemeData theme) {
    final isSelected = selectedIds.contains(item.containerTypeId.toString());

    return Padding(
      padding: EdgeInsets.symmetric(vertical: Constant.CONTAINER_SIZE_10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.containerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: Constant.SIZE_06),
                Text(
                  item.productId,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: Constant.LABEL_TEXT_SIZE_14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          Theme(
            data: ThemeData(
              checkboxTheme: CheckboxThemeData(
                side: MaterialStateBorderSide.resolveWith((states) {
                  if (states.contains(MaterialState.selected)) {
                    return BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    );
                  }
                  return const BorderSide(
                    color: Colors.blue,
                    width: 2,
                  );
                }),
              ),
            ),
            child: Checkbox(
              value: isSelected,
              activeColor: Colors.white,
              checkColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Constant.SIZE_06),
              ),
              onChanged: (value) {
                setState(() {
                  value == true
                      ? selectedIds.add(item.containerTypeId.toString())
                      : selectedIds.remove(item.containerTypeId.toString());
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
      child: SubmitClearButton(
        onLeftTap: () {
          setState(() {
            selectedIds.clear();
          });
        },
        onRightTap: () {
          setState(() {
            final selectedItems = widget.containerList
                .where(
                  (e) => selectedIds.contains(e.containerTypeId.toString()),
                )
                .toList();

            Navigator.pop(context, selectedItems);
          });
        },
      ),
    );
  }

  void _filterSearch(String value) {
    setState(() {
      filteredContainers = widget.containerList.where((item) {
        final searchLower = value.toLowerCase();
        return item.containerName.toLowerCase().contains(searchLower) ||
            item.containerTypeId.toString().toLowerCase().contains(searchLower);
      }).toList();
    });
  }
}
