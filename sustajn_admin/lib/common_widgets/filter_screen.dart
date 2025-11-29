import 'package:flutter/material.dart';
import '../constants/number_constants.dart';   // your Constant class

Future<List<Map<String, dynamic>>?> showContainerFilterBottomSheet(
    BuildContext context,
    List<Map<String, dynamic>> containerList,
    ) {
  return showModalBottomSheet<List<Map<String, dynamic>>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return _ContainerFilterSheet(containerList: containerList);
    },
  );
}

class _ContainerFilterSheet extends StatefulWidget {
  final List<Map<String, dynamic>> containerList;

  const _ContainerFilterSheet({required this.containerList});

  @override
  State<_ContainerFilterSheet> createState() => _ContainerFilterSheetState();
}

class _ContainerFilterSheetState extends State<_ContainerFilterSheet> {
  List<Map<String, dynamic>> filteredContainers = [];
  Set<String> selectedIds = {};
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredContainers = List.from(widget.containerList);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
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
    );
  }

  // ========================= UI SECTIONS =========================

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
          Text(
            "Containers",
            style: TextStyle(
              fontSize: Constant.LABEL_TEXT_SIZE_18,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(Constant.CONTAINER_SIZE_10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
              ),
              child: Icon(Icons.close, size: Constant.CONTAINER_SIZE_18),
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
        onChanged: _filterSearch,
        decoration: InputDecoration(
          hintText: "Search by container name",
          prefixIcon: Icon(Icons.search),
          contentPadding: EdgeInsets.zero,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildContainerTile(Map<String, dynamic> item, ThemeData theme) {
    final isSelected = selectedIds.contains(item['id']);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: Constant.CONTAINER_SIZE_10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: TextStyle(
                    fontSize: Constant.LABEL_TEXT_SIZE_16,
                    fontWeight: FontWeight.w600,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
                SizedBox(height: Constant.SIZE_06),
                Text(
                  item['id'],
                  style: TextStyle(
                    fontSize: Constant.LABEL_TEXT_SIZE_14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          Checkbox(
            value: isSelected,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Constant.SIZE_06),
            ),
            onChanged: (value) {
              setState(() {
                value == true
                    ? selectedIds.add(item['id'])
                    : selectedIds.remove(item['id']);
              });
            },
          )
        ],
      ),
    );
  }

  Widget _buildBottomButtons(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
      child: Row(
        children: [
          Expanded(
            child: _buildClearButton(theme),
          ),
          SizedBox(width: Constant.CONTAINER_SIZE_16),
          Expanded(
            child: _buildApplyButton(theme),
          ),
        ],
      ),
    );
  }

  Widget _buildClearButton(ThemeData theme) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: Constant.CONTAINER_SIZE_14),
        side: BorderSide(color: Colors.grey.shade400),
      ),
      onPressed: () {
        setState(() {
          selectedIds.clear();
        });
      },
      child: Text("Clear", style: TextStyle(color: Colors.black)),
    );
  }

  Widget _buildApplyButton(ThemeData theme) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFD9B649),
        padding: EdgeInsets.symmetric(vertical: Constant.CONTAINER_SIZE_14),
      ),
      onPressed: () {
        final selectedItems = widget.containerList
            .where((e) => selectedIds.contains(e['id']))
            .toList();

        Navigator.pop(context, selectedItems);
      },
      child: Text(
        "Apply",
        style: TextStyle(
          color: Colors.white,
          fontSize: Constant.LABEL_TEXT_SIZE_16,
        ),
      ),
    );
  }

  // ========================= LOGIC =========================

  void _filterSearch(String value) {
    setState(() {
      filteredContainers = widget.containerList.where((item) {
        final searchLower = value.toLowerCase();
        return item['name'].toLowerCase().contains(searchLower) ||
            item['id'].toLowerCase().contains(searchLower);
      }).toList();
    });
  }
}
