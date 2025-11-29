import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../common_widgets/custom_app_bar.dart';
import '../common_widgets/custom_back_button.dart';
import '../constants/number_constants.dart';
import '../constants/string_utils.dart';
import '../utils/theme_utils.dart';
import 'add_new_container.dart';
import 'container_details.dart';

class ContainersScreen extends StatefulWidget {
  const ContainersScreen({super.key});

  @override
  State<ContainersScreen> createState() => _ContainersScreenState();
}

class _ContainersScreenState extends State<ContainersScreen> {
  List<Map<String, dynamic>> containerList = [];
  final themeData = CustomTheme.getTheme(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeData?.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: Strings.CONTAINERS_TITLE,
        leading: CustomBackButton(),
      ).getAppBar(context),
      body: SafeArea(
        child: containerList.isEmpty
            ? _buildEmptyScreen()
            : _buildContainerList(),
      ),
      floatingActionButton :
      FloatingActionButton(
        backgroundColor: const Color(0xFF2D8F6E),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddContainerScreen()),
          );
          if (result != null) {
            setState(() {
              containerList.add(result);
            });
          }
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ) ,

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildEmptyScreen() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'No Containers added yet',
            style: TextStyle(
              fontSize: Constant.LABEL_TEXT_SIZE_16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: Constant.CONTAINER_SIZE_20),
        ],
      ),
    );
  }

  Widget _buildContainerList() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search by Container Name or ID",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                borderSide: BorderSide.none,
              ),
              suffixIcon: const Icon(Icons.filter_list),
            ),
          ),
        ),

        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_16),
            itemCount: containerList.length,
            separatorBuilder: (context, index) => Divider(
              height: Constant.CONTAINER_SIZE_12,
              thickness: 1,
              color: Colors.grey[300],
            ),
            itemBuilder: (context, index) {
              final item = containerList[index];
              return _buildContainerTile(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildContainerTile(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (context)=> ContainerDetailsScreen(containerData: item)));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: Constant.CONTAINER_SIZE_12),
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
        decoration: BoxDecoration(
          color: themeData?.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
              child: item["image"] != null
                  ? Image.file(
                item["image"] as File,
                width: 55,
                height: 55,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholderImage();
                },
              )
                  : _buildPlaceholderImage(),
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
                  SizedBox(height: 4),
                  Text(
                    item["id"]?.toString() ?? 'No ID',
                    style: TextStyle(fontSize: Constant.LABEL_TEXT_SIZE_14, color: Colors.grey),
                  ),
                  Text(
                    "${item["volume"]?.toString() ?? '0'}ml",
                    style: TextStyle(fontSize: Constant.LABEL_TEXT_SIZE_14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Text(
              item["quantity"]?.toString() ?? '0',
              style: TextStyle(
                fontSize: Constant.LABEL_TEXT_SIZE_18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),

      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 55,
      height: 55,
      color: Colors.grey[200],
      child: Icon(Icons.image, color: Colors.grey[400]),
    );
  }
}
